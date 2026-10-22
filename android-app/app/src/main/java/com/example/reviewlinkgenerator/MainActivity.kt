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

    private lateinit var webView: WebView
    private var nfcAdapter: NfcAdapter? = null
    private var pendingNfcUrl: String? = null
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

    fun startNfcWriting(url: String) {
        if (nfcAdapter == null) {
            notifyNfcError("NO_HARDWARE")
            return
        }

        if (!nfcAdapter!!.isEnabled) {
            notifyNfcError("DISABLED")
            return
        }

        pendingNfcUrl = url
        isNfcModeActive = true
        lastWriteTimestamp = 0
        writtenTagsCount = 0

        val flags = NfcAdapter.FLAG_READER_NFC_A or
                NfcAdapter.FLAG_READER_NFC_B or
                NfcAdapter.FLAG_READER_NFC_F or
                NfcAdapter.FLAG_READER_NFC_V or
                NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS

        nfcAdapter?.enableReaderMode(this, { tag ->
            handleTagDiscovered(tag)
        }, flags, null)
    }

    fun stopNfcSession() {
        isNfcModeActive = false
        pendingNfcUrl = null
        lastWriteTimestamp = 0
        try {
            nfcAdapter?.disableReaderMode(this)
        } catch (e: Exception) {
            // ignore
        }
    }

    private fun handleTagDiscovered(tag: Tag) {
        val targetUrl = pendingNfcUrl
        if (targetUrl.isNullOrEmpty() || !isNfcModeActive) return

        val now = System.currentTimeMillis()
        if (now - lastWriteTimestamp < 2200) {
            // Debounce cooldown to prevent re-triggering the same card in field
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
                // Write will overwrite whatever records were previously stored
                ndef.writeNdefMessage(message)
                ndef.close()
                lastWriteTimestamp = System.currentTimeMillis()
                writtenTagsCount++
                triggerSuccessVibration()
                notifyNfcSuccess(writtenTagsCount)
                // Reader mode stays active so the user can tap the next card!
            } else {
                // Try formatable tag
                val formatable = NdefFormatable.get(tag)
                if (formatable != null) {
                    formatable.connect()
                    formatable.format(message)
                    formatable.close()
                    lastWriteTimestamp = System.currentTimeMillis()
                    writtenTagsCount++
                    triggerSuccessVibration()
                    notifyNfcSuccess(writtenTagsCount)
                    // Reader mode stays active so the user can tap the next card!
                } else {
                    notifyNfcError("UNSUPPORTED")
                }
            }
        } catch (e: Exception) {
            notifyNfcError("WRITE_FAILED")
        }
    }

    private fun triggerSuccessVibration() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
                vibratorManager?.defaultVibrator?.vibrate(
                    VibrationEffect.createOneShot(180, VibrationEffect.DEFAULT_AMPLITUDE)
                )
            } else {
                @Suppress("DEPRECATION")
                val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator?.vibrate(
                        VibrationEffect.createOneShot(180, VibrationEffect.DEFAULT_AMPLITUDE)
                    )
                } else {
                    @Suppress("DEPRECATION")
                    vibrator?.vibrate(180)
                }
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
        fun getAppVersion(): String {
            return try {
                val pInfo = activity.packageManager.getPackageInfo(activity.packageName, 0)
                pInfo.versionName ?: "1.1.5"
            } catch (e: Exception) {
                "1.1.5"
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
