package com.example.reviewlinkgenerator

import android.annotation.SuppressLint
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.Ndef
import android.nfc.tech.NdefFormatable
import android.nfc.tech.MifareUltralight
import android.nfc.tech.NfcA
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.webkit.JavascriptInterface
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.content.ContentValues
import android.provider.MediaStore
import android.os.Environment
import android.util.Base64
import android.app.DownloadManager
import android.content.BroadcastReceiver
import android.content.IntentFilter
import java.io.OutputStream
import androidx.activity.ComponentActivity
import androidx.activity.OnBackPressedCallback
import org.json.JSONObject

class MainActivity : ComponentActivity() {

    enum class NfcOp {
        IDLE,
        WRITE,
        READ,
        PERM_LOCK,
        PWD_LOCK,
        PWD_UNLOCK
    }

    private lateinit var webView: WebView
    private var nfcAdapter: NfcAdapter? = null
    private var pendingNfcUrl: String? = null
    private var pendingPassword: String? = null
    private var currentNfcOp: NfcOp = NfcOp.IDLE
    private var isNfcModeActive: Boolean = false
    private var lastWriteTimestamp: Long = 0
    private var writtenTagsCount: Int = 0

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Dark background matching the app theme
        window.statusBarColor = Color.parseColor("#0c0a09")
        window.navigationBarColor = Color.parseColor("#0c0a09")

        nfcAdapter = NfcAdapter.getDefaultAdapter(this)

        webView = WebView(this).apply {
            setBackgroundColor(Color.parseColor("#0c0a09"))
            settings.apply {
                javaScriptEnabled = true
                domStorageEnabled = true
                allowFileAccess = true
                cacheMode = WebSettings.LOAD_DEFAULT
                useWideViewPort = true
                loadWithOverviewMode = true
                displayZoomControls = false
                builtInZoomControls = false
            }

            addJavascriptInterface(WebAppInterface(this@MainActivity, this), "AndroidNative")

            webViewClient = object : WebViewClient() {
                override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                    val url = request?.url?.toString() ?: return false
                    if (url.startsWith("file:///android_asset/")) {
                        return false
                    }
                    return try {
                        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                        startActivity(intent)
                        true
                    } catch (e: Exception) {
                        false
                    }
                }

                override fun shouldInterceptRequest(view: WebView?, request: WebResourceRequest?): WebResourceResponse? {
                    val url = request?.url ?: return null
                    val host = url.host ?: ""
                    val path = url.path ?: ""
                    if (host == "zaid-a-salameh.github.io" && path.startsWith("/google-review-link/")) {
                        val assetPath = path.removePrefix("/google-review-link/").trimStart('/')
                        if (assetPath.isNotEmpty()) {
                            try {
                                val mimeType = when {
                                    assetPath.endsWith(".css") -> "text/css"
                                    assetPath.endsWith(".js") -> "application/javascript"
                                    assetPath.endsWith(".png") -> "image/png"
                                    assetPath.endsWith(".svg") -> "image/svg+xml"
                                    assetPath.endsWith(".ico") -> "image/x-icon"
                                    assetPath.endsWith(".html") -> "text/html"
                                    else -> "text/plain"
                                }
                                val inputStream = assets.open(assetPath)
                                return WebResourceResponse(mimeType, "UTF-8", inputStream)
                            } catch (e: Exception) {
                                // Asset not found locally, let WebView load normally
                            }
                        }
                    }
                    return super.shouldInterceptRequest(view, request)
                }
            }

            webChromeClient = WebChromeClient()
        }

        setContentView(webView)
        val htmlContent = assets.open("index.html").bufferedReader().use { it.readText() }
        webView.loadDataWithBaseURL("https://zaid-a-salameh.github.io/google-review-link/", htmlContent, "text/html", "UTF-8", null)

        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                if (isNfcModeActive) {
                    stopNfcSession()
                    webView.evaluateJavascript("window.onNfcCancelled && window.onNfcCancelled();", null)
                } else if (webView.canGoBack()) {
                    webView.goBack()
                } else {
                    finish()
                }
            }
        })
    }

    override fun onPause() {
        super.onPause()
        if (isNfcModeActive) {
            stopNfcSession()
        }
    }

    private fun checkNfcReady(): Boolean {
        if (nfcAdapter == null) {
            notifyNfcError("NO_HARDWARE")
            return false
        }
        if (!nfcAdapter!!.isEnabled) {
            notifyNfcError("DISABLED")
            return false
        }
        return true
    }

    private fun enableReaderModeSafe() {
        val flags = NfcAdapter.FLAG_READER_NFC_A or
                NfcAdapter.FLAG_READER_NFC_B or
                NfcAdapter.FLAG_READER_NFC_F or
                NfcAdapter.FLAG_READER_NFC_V or
                NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS

        nfcAdapter?.enableReaderMode(this, { tag ->
            handleTagDiscovered(tag)
        }, flags, null)
    }

    fun startNfcWriting(url: String) {
        if (!checkNfcReady()) return
        currentNfcOp = NfcOp.WRITE
        pendingNfcUrl = url
        isNfcModeActive = true
        lastWriteTimestamp = 0
        writtenTagsCount = 0
        enableReaderModeSafe()
    }

    fun startNfcReading() {
        if (!checkNfcReady()) return
        currentNfcOp = NfcOp.READ
        isNfcModeActive = true
        enableReaderModeSafe()
    }

    fun startNfcPermanentLocking() {
        if (!checkNfcReady()) return
        currentNfcOp = NfcOp.PERM_LOCK
        isNfcModeActive = true
        enableReaderModeSafe()
    }

    fun startNfcPasswordLocking(pin: String) {
        if (!checkNfcReady()) return
        currentNfcOp = NfcOp.PWD_LOCK
        pendingPassword = pin
        isNfcModeActive = true
        enableReaderModeSafe()
    }

    fun startNfcPasswordUnlocking(pin: String) {
        if (!checkNfcReady()) return
        currentNfcOp = NfcOp.PWD_UNLOCK
        pendingPassword = pin
        isNfcModeActive = true
        enableReaderModeSafe()
    }

    fun stopNfcSession() {
        isNfcModeActive = false
        currentNfcOp = NfcOp.IDLE
        pendingNfcUrl = null
        pendingPassword = null
        lastWriteTimestamp = 0
        try {
            nfcAdapter?.disableReaderMode(this)
        } catch (e: Exception) {
            // ignore
        }
    }

    private fun handleTagDiscovered(tag: Tag) {
        if (!isNfcModeActive) return

        when (currentNfcOp) {
            NfcOp.WRITE -> handleWriteTag(tag)
            NfcOp.READ -> handleReadTag(tag)
            NfcOp.PERM_LOCK -> handlePermLockTag(tag)
            NfcOp.PWD_LOCK -> handlePwdLockTag(tag, pendingPassword ?: "1234")
            NfcOp.PWD_UNLOCK -> handlePwdUnlockTag(tag, pendingPassword ?: "1234")
            NfcOp.IDLE -> {}
        }
    }

    private fun isTagLost(e: Exception): Boolean {
        if (e is android.nfc.TagLostException) return true
        val msg = e.message?.lowercase() ?: ""
        return msg.contains("tag was lost") || msg.contains("tag lost") || msg.contains("connection lost") || msg.contains("broken pipe") || (msg.contains("transceive failed") && !msg.contains("auth"))
    }

    private fun handleWriteTag(tag: Tag) {
        val targetUrl = pendingNfcUrl
        if (targetUrl.isNullOrEmpty()) return

        val now = System.currentTimeMillis()
        if (now - lastWriteTimestamp < 2200) {
            return
        }

        try {
            val uriRecord = NdefRecord.createUri(Uri.parse(targetUrl))
            val message = NdefMessage(arrayOf(uriRecord))

            val ndef = Ndef.get(tag)
            if (ndef != null) {
                ndef.connect()
                if (!ndef.isWritable) {
                    ndef.close()
                    notifyNfcError("LOCKED")
                    return
                }
                if (ndef.maxSize < message.byteArrayLength) {
                    ndef.close()
                    notifyNfcError("CAPACITY")
                    return
                }
                ndef.writeNdefMessage(message)
                ndef.close()
                lastWriteTimestamp = System.currentTimeMillis()
                writtenTagsCount++
                triggerSuccessVibration()
                notifyNfcSuccess(writtenTagsCount)
            } else {
                val formatable = NdefFormatable.get(tag)
                if (formatable != null) {
                    formatable.connect()
                    formatable.format(message)
                    formatable.close()
                    lastWriteTimestamp = System.currentTimeMillis()
                    writtenTagsCount++
                    triggerSuccessVibration()
                    notifyNfcSuccess(writtenTagsCount)
                } else {
                    notifyNfcError("UNSUPPORTED")
                }
            }
        } catch (e: Exception) {
            if (isTagLost(e)) {
                notifyNfcError("TAG_LOST")
            } else {
                // Check if write failed because tag is password-protected or read-only
                var isLocked = false
                val nfca = try { NfcA.get(tag) } catch (ex: Exception) { null }
                if (nfca != null) {
                    try {
                        nfca.connect()
                        val cfg = getNtagConfig(tag, nfca)
                        val readResp = nfca.transceive(byteArrayOf(0x30.toByte(), cfg.auth0Page.toByte()))
                        if (readResp != null && readResp.size >= 4 && (readResp[3].toInt() and 0xFF) != 0xFF) {
                            isLocked = true
                        }
                        nfca.close()
                    } catch (ex: Exception) {
                        isLocked = true
                    }
                }
                if (isLocked) {
                    notifyNfcError("LOCKED")
                } else {
                    notifyNfcError("WRITE_FAILED")
                }
            }
        }
    }

    private fun handleReadTag(tag: Tag) {
        try {
            val ndef = Ndef.get(tag)
            if (ndef != null) {
                ndef.connect()
                val msg = ndef.ndefMessage
                ndef.close()
                var extractedUrl: String? = null
                if (msg != null && msg.records.isNotEmpty()) {
                    for (record in msg.records) {
                        val uri = record.toUri()
                        if (uri != null) {
                            extractedUrl = uri.toString()
                            break
                        }
                        val payload = record.payload
                        if (payload != null && payload.isNotEmpty()) {
                            val text = String(payload, Charsets.UTF_8).trim()
                            val httpIdx = text.indexOf("http")
                            if (httpIdx >= 0) {
                                extractedUrl = text.substring(httpIdx)
                                break
                            }
                        }
                    }
                }
                if (!extractedUrl.isNullOrEmpty()) {
                    triggerSuccessVibration()
                    runOnUiThread {
                        val escaped = JSONObject.quote(extractedUrl)
                        webView.evaluateJavascript("window.onNfcTagRead && window.onNfcTagRead($escaped);", null)
                    }
                    stopNfcSession()
                } else {
                    notifyNfcError("EMPTY_TAG")
                }
            } else {
                notifyNfcError("UNSUPPORTED")
            }
        } catch (e: Exception) {
            if (isTagLost(e)) {
                notifyNfcError("TAG_LOST")
            } else {
                notifyNfcError("READ_LOCKED")
            }
        }
    }

    private fun handlePermLockTag(tag: Tag) {
        try {
            val ndef = Ndef.get(tag)
            if (ndef != null) {
                ndef.connect()
                if (!ndef.canMakeReadOnly()) {
                    ndef.close()
                    notifyNfcError("CANNOT_LOCK")
                    return
                }
                val success = ndef.makeReadOnly()
                ndef.close()
                if (success) {
                    triggerSuccessVibration()
                    runOnUiThread {
                        webView.evaluateJavascript("window.onNfcLockSuccess && window.onNfcLockSuccess();", null)
                    }
                    stopNfcSession()
                } else {
                    notifyNfcError("LOCK_FAILED")
                }
            } else {
                notifyNfcError("UNSUPPORTED")
            }
        } catch (e: Exception) {
            if (isTagLost(e)) {
                notifyNfcError("TAG_LOST")
            } else {
                notifyNfcError("LOCK_FAILED")
            }
        }
    }

    private data class NtagConfig(val auth0Page: Int, val pwdPage: Int, val packPage: Int, val typeName: String)

    private fun getNtagConfig(tag: Tag, nfca: NfcA): NtagConfig {
        try {
            val ndef = Ndef.get(tag)
            if (ndef != null) {
                val max = ndef.maxSize
                if (max > 600) return NtagConfig(227, 229, 230, "NTAG216")
                if (max > 200) return NtagConfig(131, 133, 134, "NTAG215")
                if (max > 0) return NtagConfig(41, 43, 44, "NTAG213")
            }
        } catch (e: Exception) {
            // fallback
        }

        try {
            val verResp = nfca.transceive(byteArrayOf(0x60.toByte()))
            if (verResp != null && verResp.size == 8) {
                val storageSize = verResp[6].toInt() and 0xFF
                when (storageSize) {
                    0x0F -> return NtagConfig(41, 43, 44, "NTAG213")
                    0x11 -> return NtagConfig(131, 133, 134, "NTAG215")
                    0x13 -> return NtagConfig(227, 229, 230, "NTAG216")
                }
            }
        } catch (e: Exception) {
            // fallback
        }

        return NtagConfig(131, 133, 134, "NTAG215")
    }

    private fun deriveNfcToolsPasswordBytes(pin: String): ByteArray {
        val md = java.security.MessageDigest.getInstance("MD5")
        val hash = md.digest(pin.trim().toByteArray(Charsets.UTF_8))
        return hash.copyOfRange(0, 4)
    }

    private fun deriveLegacyPasswordBytes(pin: String): ByteArray {
        val trimmed = pin.trim()
        if (trimmed.length == 4) {
            return trimmed.toByteArray(Charsets.UTF_8)
        }
        val md = java.security.MessageDigest.getInstance("SHA-256")
        val hash = md.digest(trimmed.toByteArray(Charsets.UTF_8))
        return hash.copyOfRange(0, 4)
    }

    private fun handlePwdLockTag(tag: Tag, pin: String) {
        try {
            val nfca = NfcA.get(tag)
            if (nfca == null) {
                notifyNfcError("PWD_UNSUPPORTED")
                return
            }
            nfca.connect()
            nfca.timeout = 3000
            val cfg = getNtagConfig(tag, nfca)
            val pwdBytes = deriveNfcToolsPasswordBytes(pin)

            // Check if tag is already locked
            var isAlreadyLocked = false
            try {
                val readResp = nfca.transceive(byteArrayOf(0x30.toByte(), cfg.auth0Page.toByte()))
                if (readResp != null && readResp.size >= 4) {
                    val currentAuth0 = readResp[3].toInt() and 0xFF
                    if (currentAuth0 != 0xFF) {
                        isAlreadyLocked = true
                    }
                }
            } catch (e: Exception) {
                isAlreadyLocked = true
            }

            if (isAlreadyLocked) {
                // If tag is already locked, authenticate first before updating
                var authSuccess = false
                val authCmd = byteArrayOf(0x1B.toByte(), pwdBytes[0], pwdBytes[1], pwdBytes[2], pwdBytes[3])
                try {
                    val resp = nfca.transceive(authCmd)
                    if (resp != null && resp.size >= 2) authSuccess = true
                } catch (e: Exception) { }

                if (!authSuccess) {
                    // Try legacy password authentication if user is re-locking an older card
                    val legacyPwd = deriveLegacyPasswordBytes(pin)
                    try {
                        nfca.close()
                        nfca.connect()
                        nfca.timeout = 3000
                        val authCmdLegacy = byteArrayOf(0x1B.toByte(), legacyPwd[0], legacyPwd[1], legacyPwd[2], legacyPwd[3])
                        val resp = nfca.transceive(authCmdLegacy)
                        if (resp != null && resp.size >= 2) authSuccess = true
                    } catch (e2: Exception) { }
                }

                if (!authSuccess) {
                    nfca.close()
                    notifyNfcError("ALREADY_LOCKED")
                    return
                }
            }

            // Write PWD (page cfg.pwdPage) - MD5 first 4 bytes (NFC Tools standard)
            val writePwdCmd = byteArrayOf(0xA2.toByte(), cfg.pwdPage.toByte(), pwdBytes[0], pwdBytes[1], pwdBytes[2], pwdBytes[3])
            nfca.transceive(writePwdCmd)

            // Write PACK (page cfg.packPage) - 00 00 00 00 (NFC Tools standard)
            val writePackCmd = byteArrayOf(0xA2.toByte(), cfg.packPage.toByte(), 0x00, 0x00, 0x00, 0x00)
            nfca.transceive(writePackCmd)

            // Write AUTH0 (page cfg.auth0Page) - 00 00 00 04 (NFC Tools standard, protect from page 4)
            val writeAuth0Cmd = byteArrayOf(0xA2.toByte(), cfg.auth0Page.toByte(), 0x00, 0x00, 0x00, 0x04.toByte())
            nfca.transceive(writeAuth0Cmd)

            nfca.close()
            triggerSuccessVibration()
            runOnUiThread {
                webView.evaluateJavascript("window.onNfcPasswordSuccess && window.onNfcPasswordSuccess('LOCKED');", null)
            }
            stopNfcSession()
        } catch (e: Exception) {
            if (isTagLost(e)) {
                notifyNfcError("TAG_LOST")
            } else {
                notifyNfcError("PWD_FAILED")
            }
        }
    }

    private fun handlePwdUnlockTag(tag: Tag, pin: String) {
        try {
            val nfca = NfcA.get(tag)
            if (nfca == null) {
                notifyNfcError("PWD_UNSUPPORTED")
                return
            }
            nfca.connect()
            nfca.timeout = 3000
            val cfg = getNtagConfig(tag, nfca)

            // 1. Check if the card is already unlocked (AUTH0 == 0xFF)
            var isLocked = false
            try {
                val readResp = nfca.transceive(byteArrayOf(0x30.toByte(), cfg.auth0Page.toByte()))
                if (readResp != null && readResp.size >= 4) {
                    val currentAuth0 = readResp[3].toInt() and 0xFF
                    if (currentAuth0 != 0xFF) {
                        isLocked = true
                    }
                }
            } catch (e: Exception) {
                // If read failed (e.g. read protection active), card is locked
                isLocked = true
            }

            if (!isLocked) {
                // Card is already completely unlocked!
                nfca.close()
                triggerSuccessVibration()
                runOnUiThread {
                    webView.evaluateJavascript("window.onNfcPasswordSuccess && window.onNfcPasswordSuccess('ALREADY_UNLOCKED');", null)
                }
                stopNfcSession()
                return
            }

            // 2. Card IS locked. We must authenticate with the PIN!
            val md5Pwd = deriveNfcToolsPasswordBytes(pin)
            val legacyPwd = deriveLegacyPasswordBytes(pin)

            var authenticated = false

            // Try 1: NFC Tools standard MD5 password
            try {
                val authCmd1 = byteArrayOf(0x1B.toByte(), md5Pwd[0], md5Pwd[1], md5Pwd[2], md5Pwd[3])
                val resp1 = nfca.transceive(authCmd1)
                if (resp1 != null && resp1.size >= 2) {
                    authenticated = true
                }
            } catch (e: Exception) {
                authenticated = false
            }

            // Try 2: Legacy raw ASCII password (if card was locked with older version of app)
            if (!authenticated) {
                try {
                    nfca.close()
                    nfca.connect()
                    nfca.timeout = 3000
                    val authCmd2 = byteArrayOf(0x1B.toByte(), legacyPwd[0], legacyPwd[1], legacyPwd[2], legacyPwd[3])
                    val resp2 = nfca.transceive(authCmd2)
                    if (resp2 != null && resp2.size >= 2) {
                        authenticated = true
                    }
                } catch (e: Exception) {
                    authenticated = false
                }
            }

            if (authenticated) {
                // Disable password protection by setting AUTH0 to 0xFF (NFC Tools standard)
                val disableCmd = byteArrayOf(0xA2.toByte(), cfg.auth0Page.toByte(), 0x00, 0x00, 0x00, 0xFF.toByte())
                nfca.transceive(disableCmd)

                // Reset PWD to factory FF FF FF FF
                try {
                    val resetPwdCmd = byteArrayOf(0xA2.toByte(), cfg.pwdPage.toByte(), 0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte())
                    nfca.transceive(resetPwdCmd)
                } catch (e: Exception) { }

                // Reset PACK to factory 00 00 00 00
                try {
                    val resetPackCmd = byteArrayOf(0xA2.toByte(), cfg.packPage.toByte(), 0x00, 0x00, 0x00, 0x00)
                    nfca.transceive(resetPackCmd)
                } catch (e: Exception) { }

                // If chip is NTAG215/216 and page 41 had old stray bytes, clean page 41
                if (cfg.auth0Page != 41) {
                    try {
                        val p41 = nfca.transceive(byteArrayOf(0x30.toByte(), 41.toByte()))
                        if (p41 != null && (p41[0].toInt() and 0xFF) == 0xFF) {
                            nfca.transceive(byteArrayOf(0xA2.toByte(), 41.toByte(), 0x00, 0x00, 0x00, 0x00))
                        }
                    } catch (e: Exception) { }
                }

                nfca.close()
                triggerSuccessVibration()
                runOnUiThread {
                    webView.evaluateJavascript("window.onNfcPasswordSuccess && window.onNfcPasswordSuccess('UNLOCKED');", null)
                }
                stopNfcSession()
            } else {
                nfca.close()
                notifyNfcError("WRONG_PWD")
            }
        } catch (e: Exception) {
            if (isTagLost(e)) {
                notifyNfcError("TAG_LOST")
            } else {
                notifyNfcError("WRONG_PWD")
            }
        }
    }

    fun triggerSuccessVibration() {
        try {
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
                vm?.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            } ?: return

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val timings = longArrayOf(0, 140, 70, 180)
                val amplitudes = intArrayOf(0, 220, 0, 255)
                val effect = VibrationEffect.createWaveform(timings, amplitudes, -1)
                vibrator.vibrate(effect)
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(longArrayOf(0, 140, 70, 180), -1)
            }
        } catch (e: Exception) {
            // vibration is optional
        }
    }

    fun triggerErrorVibration() {
        try {
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
                vm?.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            } ?: return

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val timings = longArrayOf(0, 100, 70, 100, 70, 100)
                val amplitudes = intArrayOf(0, 220, 0, 220, 0, 255)
                val effect = VibrationEffect.createWaveform(timings, amplitudes, -1)
                vibrator.vibrate(effect)
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(longArrayOf(0, 100, 70, 100, 70, 100), -1)
            }
        } catch (e: Exception) {
            // vibration is optional
        }
    }

    private fun notifyNfcSuccess(count: Int) {
        runOnUiThread {
            webView.evaluateJavascript("window.onNfcSuccess && window.onNfcSuccess($count);", null)
        }
    }

    private fun notifyNfcError(errorCode: String) {
        triggerErrorVibration()
        runOnUiThread {
            webView.evaluateJavascript("window.onNfcError && window.onNfcError('$errorCode');", null)
        }
    }

    fun handleApkUpdate(downloadUrl: String) {
        try {
            val uri = Uri.parse(downloadUrl)
            val request = DownloadManager.Request(uri).apply {
                setTitle("ReviewLinkGenerator Update")
                setDescription("Downloading updated APK...")
                setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
                setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, "ReviewLinkGenerator.apk")
                setMimeType("application/vnd.android.package-archive")
            }

            val dm = getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
            val downloadId = dm.enqueue(request)

            val receiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent?) {
                    val id = intent?.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1)
                    if (id == downloadId) {
                        try {
                            val fileUri = dm.getUriForDownloadedFile(downloadId)
                            if (fileUri != null) {
                                val installIntent = Intent(Intent.ACTION_VIEW).apply {
                                    setDataAndType(fileUri, "application/vnd.android.package-archive")
                                    flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                startActivity(installIntent)
                            }
                        } catch (e: Exception) {
                            try {
                                val viewIntent = Intent(DownloadManager.ACTION_VIEW_DOWNLOADS).apply {
                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                startActivity(viewIntent)
                            } catch (ex: Exception) {
                                // Ignored
                            }
                        }
                        try {
                            unregisterReceiver(this)
                        } catch (e: Exception) {
                            // Ignored
                        }
                    }
                }
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(receiver, IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE), Context.RECEIVER_EXPORTED)
            } else {
                registerReceiver(receiver, IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE))
            }
        } catch (e: Exception) {
            try {
                val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(downloadUrl)).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                startActivity(browserIntent)
            } catch (ex: Exception) {
                runOnUiThread {
                    webView.evaluateJavascript("window.onApkUpdateError && window.onApkUpdateError();", null)
                }
            }
        }
    }

    class WebAppInterface(private val activity: MainActivity, private val webView: WebView) {

        @JavascriptInterface
        fun triggerHapticFeedback() {
            activity.triggerSuccessVibration()
        }

        @JavascriptInterface
        fun getAppVersion(): String {
            return try {
                val pInfo = activity.packageManager.getPackageInfo(activity.packageName, 0)
                pInfo.versionName ?: "1.2.1"
            } catch (e: Exception) {
                "1.2.1"
            }
        }

        @JavascriptInterface
        fun downloadAndInstallApk(url: String) {
            activity.runOnUiThread {
                activity.handleApkUpdate(url)
            }
        }

        @JavascriptInterface
        fun pasteFromClipboard() {
            activity.runOnUiThread {
                try {
                    val clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                    val clip = clipboard.primaryClip
                    if (clip != null && clip.itemCount > 0) {
                        val text = clip.getItemAt(0).coerceToText(activity).toString().trim()
                        if (text.isNotEmpty()) {
                            val escaped = JSONObject.quote(text)
                            webView.evaluateJavascript("window.onNativePaste && window.onNativePaste($escaped);", null)
                        } else {
                            webView.evaluateJavascript("window.onNativePaste && window.onNativePaste('');", null)
                        }
                    } else {
                        webView.evaluateJavascript("window.onNativePaste && window.onNativePaste('');", null)
                    }
                } catch (e: Exception) {
                    webView.evaluateJavascript("window.onNativePaste && window.onNativePaste('');", null)
                }
            }
        }

        @JavascriptInterface
        fun copyToClipboard(text: String) {
            activity.runOnUiThread {
                val clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                val clip = ClipData.newPlainText("Review Link", text)
                clipboard.setPrimaryClip(clip)
            }
        }

        @JavascriptInterface
        fun shareText(text: String, title: String) {
            val sendIntent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_TEXT, text)
                type = "text/plain"
            }
            val shareIntent = Intent.createChooser(sendIntent, title)
            shareIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            activity.startActivity(shareIntent)
        }

        @JavascriptInterface
        fun isNfcAvailable(): Boolean {
            val adapter = activity.nfcAdapter ?: return false
            return adapter.isEnabled
        }

        @JavascriptInterface
        fun isNetworkConnected(): Boolean {
            return try {
                val cm = activity.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager ?: return false
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    val network = cm.activeNetwork ?: return false
                    val caps = cm.getNetworkCapabilities(network) ?: return false
                    caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                } else {
                    @Suppress("DEPRECATION")
                    val ni = cm.activeNetworkInfo ?: return false
                    @Suppress("DEPRECATION")
                    ni.isConnected
                }
            } catch (e: Exception) {
                false
            }
        }

        @JavascriptInterface
        fun startNfcWrite(url: String) {
            activity.runOnUiThread {
                activity.startNfcWriting(url)
            }
        }

        @JavascriptInterface
        fun startNfcRead() {
            activity.runOnUiThread {
                activity.startNfcReading()
            }
        }

        @JavascriptInterface
        fun startNfcPermanentLock() {
            activity.runOnUiThread {
                activity.startNfcPermanentLocking()
            }
        }

        @JavascriptInterface
        fun startNfcPasswordLock(pin: String) {
            activity.runOnUiThread {
                activity.startNfcPasswordLocking(pin)
            }
        }

        @JavascriptInterface
        fun startNfcPasswordUnlock(pin: String) {
            activity.runOnUiThread {
                activity.startNfcPasswordUnlocking(pin)
            }
        }

        @JavascriptInterface
        fun cancelNfcWrite() {
            activity.runOnUiThread {
                activity.stopNfcSession()
            }
        }

        @JavascriptInterface
        fun saveQrImage(dataUrl: String, filename: String) {
            activity.runOnUiThread {
                try {
                    val cleanBase64 = dataUrl.substringAfter("base64,")
                    val decodedBytes = Base64.decode(cleanBase64, Base64.DEFAULT)
                    val bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)

                    val contentValues = ContentValues().apply {
                        put(MediaStore.MediaColumns.DISPLAY_NAME, filename)
                        put(MediaStore.MediaColumns.MIME_TYPE, "image/png")
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES + "/ReviewLinks")
                            put(MediaStore.MediaColumns.IS_PENDING, 1)
                        }
                    }

                    val uri = activity.contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
                    if (uri != null) {
                        activity.contentResolver.openOutputStream(uri)?.use { outStream ->
                            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream)
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            contentValues.clear()
                            contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
                            activity.contentResolver.update(uri, contentValues, null, null)
                        }
                    } else {
                        webView.evaluateJavascript("window.onSaveQrError && window.onSaveQrError();", null)
                    }
                } catch (e: Exception) {
                    webView.evaluateJavascript("window.onSaveQrError && window.onSaveQrError();", null)
                }
            }
        }
    }
}
