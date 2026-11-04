package com.example.reviewlinkgenerator

import android.app.DownloadManager
import android.content.BroadcastReceiver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.TagLostException
import android.nfc.tech.Ndef
import android.nfc.tech.NdefFormatable
import android.nfc.tech.NfcA
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.MediaStore
import androidx.core.content.ContextCompat
import androidx.core.view.WindowInsetsControllerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.security.MessageDigest

class MainActivity : FlutterActivity() {

    enum class NfcOp {
        IDLE,
        WRITE,
        READ,
        PERM_LOCK,
        PWD_LOCK,
        PWD_UNLOCK,
        WRITE_WIFI,
        ERASE
    }

    companion object {
        private const val HARDWARE_CHANNEL = "com.example.reviewlinkgenerator/hardware"
        private const val NFC_EVENTS_CHANNEL = "com.example.reviewlinkgenerator/nfc_events"
    }

    private var nfcAdapter: NfcAdapter? = null
    private var eventSink: EventChannel.EventSink? = null

    private var pendingNfcUrl: String? = null
    private var pendingPassword: String? = null
    private var pendingWifiSsid: String? = null
    private var pendingWifiPassword: String? = null
    private var pendingWifiEncType: String? = null

    @Volatile
    private var currentNfcOp: NfcOp = NfcOp.IDLE

    @Volatile
    private var isNfcModeActive: Boolean = false

    private var lastWriteTimestamp: Long = 0
    private var lastWrittenTagId: ByteArray? = null
    private var writtenTagsCount: Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val appBgColor = Color.parseColor("#0C0A09")
        window.decorView.setBackgroundColor(appBgColor)
        @Suppress("DEPRECATION")
        window.statusBarColor = appBgColor
        @Suppress("DEPRECATION")
        window.navigationBarColor = appBgColor
        WindowInsetsControllerCompat(window, window.decorView).apply {
            isAppearanceLightStatusBars = false
            isAppearanceLightNavigationBars = false
        }

        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, NFC_EVENTS_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, HARDWARE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getNfcStatus" -> {
                        val adapter = nfcAdapter
                        val status = when {
                            adapter == null -> "NO_HARDWARE"
                            !adapter.isEnabled -> "DISABLED"
                            else -> "READY"
                        }
                        result.success(status)
                    }

                    "isNfcAvailable" -> {
                        val adapter = nfcAdapter
                        result.success(adapter != null && adapter.isEnabled)
                    }

                    "isNetworkConnected" -> {
                        result.success(checkNetworkConnected())
                    }

                    "getAppVersion" -> {
                        result.success(resolveAppVersion())
                    }

                    "triggerSuccessHaptic" -> {
                        triggerSuccessVibration()
                        result.success(true)
                    }

                    "triggerErrorHaptic" -> {
                        triggerErrorVibration()
                        result.success(true)
                    }

                    "triggerLightHaptic" -> {
                        triggerLightHaptic()
                        result.success(true)
                    }

                    "startNfcWrite" -> {
                        val url = call.argument<String>("url") ?: ""
                        startNfcWriting(url)
                        result.success(true)
                    }

                    "startNfcWifiWrite" -> {
                        val ssid = call.argument<String>("ssid") ?: ""
                        val password = call.argument<String>("password") ?: ""
                        val encType = call.argument<String>("encType") ?: "WPA"
                        startNfcWifiWriting(ssid, password, encType)
                        result.success(true)
                    }

                    "startNfcRead" -> {
                        startNfcReading()
                        result.success(true)
                    }

                    "startNfcPermanentLock" -> {
                        startNfcPermanentLocking()
                        result.success(true)
                    }

                    "startNfcErase" -> {
                        startNfcErasing()
                        result.success(true)
                    }

                    "startNfcPasswordLock" -> {
                        val pin = call.argument<String>("pin") ?: ""
                        startNfcPasswordLocking(pin)
                        result.success(true)
                    }

                    "startNfcPasswordUnlock" -> {
                        val pin = call.argument<String>("pin") ?: ""
                        startNfcPasswordUnlocking(pin)
                        result.success(true)
                    }

                    "pauseNfcSession" -> {
                        pauseNfcSession()
                        result.success(true)
                    }

                    "cancelNfcSession" -> {
                        stopNfcSession()
                        result.success(true)
                    }

                    "saveQrImage" -> {
                        val bytes = call.argument<ByteArray>("bytes")
                        val filename = call.argument<String>("filename") ?: "review-qr.png"
                        if (bytes == null || bytes.isEmpty()) {
                            result.success(false)
                        } else {
                            result.success(saveQrPngBytes(bytes, filename))
                        }
                    }

                    "downloadAndInstallApk" -> {
                        val url = call.argument<String>("url") ?: ""
                        if (url.isBlank()) {
                            result.success(false)
                        } else {
                            result.success(handleApkUpdate(url))
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    override fun onPause() {
        super.onPause()
        if (isNfcModeActive) {
            stopNfcSession()
            emitEvent(mapOf("event" to "session_paused"))
        }
        disableReaderModeSafe()
    }

    override fun onResume() {
        super.onResume()
        enableReaderModeSafe()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    private fun emitEvent(payload: Map<String, Any?>) {
        runOnUiThread {
            eventSink?.success(payload)
        }
    }

    private fun resolveAppVersion(): String {
        return try {
            val pInfo = packageManager.getPackageInfo(packageName, 0)
            pInfo.versionName ?: "1.2.1"
        } catch (_: Exception) {
            "1.2.1"
        }
    }

    private fun checkNetworkConnected(): Boolean {
        return try {
            val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager ?: return false
            val network = cm.activeNetwork ?: return false
            val caps = cm.getNetworkCapabilities(network) ?: return false
            caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
        } catch (_: Exception) {
            false
        }
    }

    private fun checkNfcReady(): Boolean {
        val adapter = nfcAdapter
        if (adapter == null) {
            notifyNfcError("NO_HARDWARE")
            return false
        }
        if (!adapter.isEnabled) {
            notifyNfcError("DISABLED")
            return false
        }
        return true
    }

    private fun enableReaderModeSafe() {
        val adapter = nfcAdapter ?: return
        if (!adapter.isEnabled) return
        val flags = NfcAdapter.FLAG_READER_NFC_A or
            NfcAdapter.FLAG_READER_NFC_B or
            NfcAdapter.FLAG_READER_NFC_F or
            NfcAdapter.FLAG_READER_NFC_V or
            NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS

        try {
            adapter.enableReaderMode(
                this,
                { tag -> handleTagDiscovered(tag) },
                flags,
                null
            )
        } catch (_: Exception) {
            // Ignored if lifecycle is transitioning
        }
    }

    private fun disableReaderModeSafe() {
        try {
            nfcAdapter?.disableReaderMode(this)
        } catch (_: Exception) {
            // Ignored
        }
    }

    private fun startNfcWriting(url: String) {
        if (!checkNfcReady()) return
        val isContinuingBatch =
            ((currentNfcOp == NfcOp.WRITE || currentNfcOp == NfcOp.IDLE) && pendingNfcUrl == url) && writtenTagsCount > 0
        currentNfcOp = NfcOp.WRITE
        pendingNfcUrl = url
        isNfcModeActive = true
        lastWriteTimestamp = 0
        lastWrittenTagId = null
        if (!isContinuingBatch) {
            writtenTagsCount = 0
        }
        enableReaderModeSafe()
    }

    private fun startNfcReading() {
        if (!checkNfcReady()) return
        currentNfcOp = NfcOp.READ
        isNfcModeActive = true
        enableReaderModeSafe()
    }

    private fun startNfcPermanentLocking() {
        if (!checkNfcReady()) return
        currentNfcOp = NfcOp.PERM_LOCK
        isNfcModeActive = true
        enableReaderModeSafe()
    }

    private fun startNfcErasing() {
        if (!checkNfcReady()) return
        currentNfcOp = NfcOp.ERASE
        isNfcModeActive = true
        lastWriteTimestamp = 0
        lastWrittenTagId = null
        enableReaderModeSafe()
    }

    private fun startNfcPasswordLocking(pin: String) {
        if (!checkNfcReady()) return
        if (pin.isBlank()) {
            stopNfcSession()
            notifyNfcError("MISSING_PIN")
            return
        }
        currentNfcOp = NfcOp.PWD_LOCK
        pendingPassword = pin
        isNfcModeActive = true
        enableReaderModeSafe()
    }

    private fun startNfcPasswordUnlocking(pin: String) {
        if (!checkNfcReady()) return
        if (pin.isBlank()) {
            stopNfcSession()
            notifyNfcError("MISSING_PIN")
            return
        }
        currentNfcOp = NfcOp.PWD_UNLOCK
        pendingPassword = pin
        isNfcModeActive = true
        enableReaderModeSafe()
    }

    private fun startNfcWifiWriting(ssid: String, password: String, encType: String) {
        if (!checkNfcReady()) return
        if (ssid.isBlank()) {
            stopNfcSession()
            notifyNfcError("MISSING_SSID")
            return
        }
        val isContinuingBatch =
            ((currentNfcOp == NfcOp.WRITE_WIFI || currentNfcOp == NfcOp.IDLE) && pendingWifiSsid == ssid) && writtenTagsCount > 0
        currentNfcOp = NfcOp.WRITE_WIFI
        pendingWifiSsid = ssid
        pendingWifiPassword = password
        pendingWifiEncType = encType
        isNfcModeActive = true
        lastWriteTimestamp = 0
        lastWrittenTagId = null
        if (!isContinuingBatch) {
            writtenTagsCount = 0
        }
        enableReaderModeSafe()
    }

    private fun pauseNfcSession() {
        isNfcModeActive = false
        currentNfcOp = NfcOp.IDLE
        lastWriteTimestamp = 0
        lastWrittenTagId = null
    }

    private fun stopNfcSession() {
        isNfcModeActive = false
        currentNfcOp = NfcOp.IDLE
        pendingNfcUrl = null
        pendingPassword = null
        pendingWifiSsid = null
        pendingWifiPassword = null
        pendingWifiEncType = null
        lastWriteTimestamp = 0
        lastWrittenTagId = null
        writtenTagsCount = 0
    }

    private fun handleTagDiscovered(tag: Tag) {
        if (!isNfcModeActive || currentNfcOp == NfcOp.IDLE) {
            // Silently absorb NFC tags scanned while inside the app without an active operation.
            return
        }

        when (currentNfcOp) {
            NfcOp.WRITE -> handleWriteTag(tag)
            NfcOp.WRITE_WIFI -> handleWriteWifiTag(tag)
            NfcOp.READ -> handleReadTag(tag)
            NfcOp.PERM_LOCK -> handlePermLockTag(tag)
            NfcOp.ERASE -> handleEraseTag(tag)
            NfcOp.PWD_LOCK -> {
                val pin = pendingPassword
                if (pin.isNullOrBlank()) {
                    stopNfcSession()
                    notifyNfcError("MISSING_PIN")
                } else {
                    handlePwdLockTag(tag, pin)
                }
            }
            NfcOp.PWD_UNLOCK -> {
                val pin = pendingPassword
                if (pin.isNullOrBlank()) {
                    stopNfcSession()
                    notifyNfcError("MISSING_PIN")
                } else {
                    handlePwdUnlockTag(tag, pin)
                }
            }
            NfcOp.IDLE -> {}
        }
    }

    private fun isTagLost(e: Exception): Boolean {
        if (e is TagLostException) return true
        val msg = e.message?.lowercase() ?: ""
        return msg.contains("tag was lost") ||
            msg.contains("tag lost") ||
            msg.contains("connection lost") ||
            msg.contains("broken pipe") ||
            (msg.contains("transceive failed") && !msg.contains("auth"))
    }

    private fun handleWriteTag(tag: Tag) {
        val targetUrl = pendingNfcUrl
        if (targetUrl.isNullOrEmpty()) return

        val tagId = tag.id
        val now = System.currentTimeMillis()
        if (tagId != null && lastWrittenTagId?.contentEquals(tagId) == true && now - lastWriteTimestamp < 1500L) {
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
                lastWrittenTagId = tagId?.clone()
                writtenTagsCount++
                triggerSuccessVibration()
                pauseNfcSession()
                emitEvent(
                    mapOf(
                        "event" to "write_success",
                        "count" to writtenTagsCount,
                        "op" to "WRITE"
                    )
                )
            } else {
                val formatable = NdefFormatable.get(tag)
                if (formatable != null) {
                    formatable.connect()
                    formatable.format(message)
                    formatable.close()
                    lastWriteTimestamp = System.currentTimeMillis()
                    lastWrittenTagId = tagId?.clone()
                    writtenTagsCount++
                    triggerSuccessVibration()
                    pauseNfcSession()
                    emitEvent(
                        mapOf(
                            "event" to "write_success",
                            "count" to writtenTagsCount,
                            "op" to "WRITE"
                        )
                    )
                } else {
                    notifyNfcError("UNSUPPORTED")
                }
            }
        } catch (e: Exception) {
            if (isTagLost(e)) {
                notifyNfcError("TAG_LOST")
            } else if (checkIfNtagPasswordProtected(tag)) {
                notifyNfcError("LOCKED")
            } else {
                notifyNfcError("WRITE_FAILED")
            }
        }
    }

    private fun checkIfNtagPasswordProtected(tag: Tag): Boolean {
        var isLocked = false
        val nfca = try {
            NfcA.get(tag)
        } catch (_: Exception) {
            null
        }
        if (nfca != null) {
            try {
                nfca.connect()
                val cfg = getNtagConfig(tag, nfca)
                if (cfg != null) {
                    val readResp = nfca.transceive(byteArrayOf(0x30.toByte(), cfg.auth0Page.toByte()))
                    if (readResp != null && readResp.size >= 4 && (readResp[3].toInt() and 0xFF) != 0xFF) {
                        isLocked = true
                    }
                }
                nfca.close()
            } catch (_: Exception) {
                isLocked = true
            }
        }
        return isLocked
    }

    private fun buildWscPayload(ssid: String, password: String, encType: String): ByteArray {
        val stream = ByteArrayOutputStream()
        val credStream = ByteArrayOutputStream()

        fun writeTlv(out: ByteArrayOutputStream, id: Int, value: ByteArray) {
            out.write((id shr 8) and 0xFF)
            out.write(id and 0xFF)
            out.write((value.size shr 8) and 0xFF)
            out.write(value.size and 0xFF)
            out.write(value)
        }

        // 1. Network Index: 1
        writeTlv(credStream, 0x1026, byteArrayOf(0x01))

        // 2. SSID
        writeTlv(credStream, 0x1045, ssid.toByteArray(Charsets.UTF_8))

        // 3. Auth Type & 4. Encryption Type
        val authVal: Short
        val encVal: Short
        when (encType.uppercase()) {
            "OPEN", "NONE" -> {
                authVal = 0x0001
                encVal = 0x0001
            }
            "WEP" -> {
                authVal = 0x0001
                encVal = 0x0002
            }
            else -> {
                authVal = 0x0022
                encVal = 0x000C
            }
        }

        val authBytes = byteArrayOf(((authVal.toInt() shr 8) and 0xFF).toByte(), (authVal.toInt() and 0xFF).toByte())
        writeTlv(credStream, 0x1003, authBytes)

        val encBytes = byteArrayOf(((encVal.toInt() shr 8) and 0xFF).toByte(), (encVal.toInt() and 0xFF).toByte())
        writeTlv(credStream, 0x100F, encBytes)

        // 5. Network Key (Password)
        if (encType.uppercase() != "OPEN" && encType.uppercase() != "NONE" && password.isNotEmpty()) {
            writeTlv(credStream, 0x1027, password.toByteArray(Charsets.UTF_8))
        }

        // 6. MAC Address (broadcast wildcard FF:FF:FF:FF:FF:FF)
        writeTlv(
            credStream,
            0x1020,
            byteArrayOf(
                0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte(),
                0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte()
            )
        )

        val credBytes = credStream.toByteArray()
        writeTlv(stream, 0x100E, credBytes)
        return stream.toByteArray()
    }

    private fun handleWriteWifiTag(tag: Tag) {
        val ssid = pendingWifiSsid
        val password = pendingWifiPassword ?: ""
        val encType = pendingWifiEncType ?: "WPA"
        if (ssid.isNullOrEmpty()) return

        val tagId = tag.id
        val now = System.currentTimeMillis()
        if (tagId != null && lastWrittenTagId?.contentEquals(tagId) == true && now - lastWriteTimestamp < 1500L) {
            return
        }

        try {
            val wscPayload = buildWscPayload(ssid, password, encType)
            val wscRecord = NdefRecord.createMime("application/vnd.wfa.wsc", wscPayload)
            val wscMessage = NdefMessage(arrayOf(wscRecord))

            val ndef = Ndef.get(tag)
            if (ndef != null) {
                ndef.connect()
                if (!ndef.isWritable) {
                    ndef.close()
                    notifyNfcError("LOCKED")
                    return
                }
                if (ndef.maxSize < wscMessage.byteArrayLength) {
                    ndef.close()
                    notifyNfcError("CAPACITY")
                    return
                }
                ndef.writeNdefMessage(wscMessage)
                ndef.close()
                lastWriteTimestamp = System.currentTimeMillis()
                lastWrittenTagId = tagId?.clone()
                writtenTagsCount++
                triggerSuccessVibration()
                pauseNfcSession()
                emitEvent(
                    mapOf(
                        "event" to "write_success",
                        "count" to writtenTagsCount,
                        "op" to "WRITE_WIFI"
                    )
                )
            } else {
                val formatable = NdefFormatable.get(tag)
                if (formatable != null) {
                    formatable.connect()
                    formatable.format(wscMessage)
                    formatable.close()
                    lastWriteTimestamp = System.currentTimeMillis()
                    lastWrittenTagId = tagId?.clone()
                    writtenTagsCount++
                    triggerSuccessVibration()
                    pauseNfcSession()
                    emitEvent(
                        mapOf(
                            "event" to "write_success",
                            "count" to writtenTagsCount,
                            "op" to "WRITE_WIFI"
                        )
                    )
                } else {
                    notifyNfcError("UNSUPPORTED")
                }
            }
        } catch (e: Exception) {
            if (isTagLost(e)) {
                notifyNfcError("TAG_LOST")
            } else if (checkIfNtagPasswordProtected(tag)) {
                notifyNfcError("LOCKED")
            } else {
                notifyNfcError("WRITE_FAILED")
            }
        }
    }

    data class ParsedWifiConfig(val ssid: String, val password: String, val encType: String)

    private fun parseWscPayload(payload: ByteArray): ParsedWifiConfig? {
        var ssid: String? = null
        var password = ""
        var authTypeVal: Int? = null
        var encrTypeVal: Int? = null

        fun parseTlvs(bytes: ByteArray, startOffset: Int, endOffset: Int) {
            var i = startOffset
            while (i + 4 <= endOffset) {
                val type = ((bytes[i].toInt() and 0xFF) shl 8) or (bytes[i + 1].toInt() and 0xFF)
                val len = ((bytes[i + 2].toInt() and 0xFF) shl 8) or (bytes[i + 3].toInt() and 0xFF)
                i += 4
                if (i + len > endOffset) break

                when (type) {
                    0x100E -> parseTlvs(bytes, i, i + len)
                    0x1045 -> ssid = String(bytes, i, len, Charsets.UTF_8).trim()
                    0x1027 -> password = String(bytes, i, len, Charsets.UTF_8)
                    0x1003 -> {
                        if (len >= 2) {
                            authTypeVal = ((bytes[i].toInt() and 0xFF) shl 8) or (bytes[i + 1].toInt() and 0xFF)
                        }
                    }
                    0x100F -> {
                        if (len >= 2) {
                            encrTypeVal = ((bytes[i].toInt() and 0xFF) shl 8) or (bytes[i + 1].toInt() and 0xFF)
                        }
                    }
                }
                i += len
            }
        }

        try {
            parseTlvs(payload, 0, payload.size)
        } catch (_: Exception) {
            return null
        }

        val resolvedSsid = ssid
        if (resolvedSsid.isNullOrEmpty()) return null
        val finalEnc = when {
            encrTypeVal == 0x0002 || authTypeVal == 0x0004 -> "WEP"
            authTypeVal == 0x0001 && (encrTypeVal == null || encrTypeVal == 0x0001) -> "OPEN"
            authTypeVal != null || encrTypeVal != null -> "WPA"
            password.isNotEmpty() -> "WPA"
            else -> "OPEN"
        }
        return ParsedWifiConfig(resolvedSsid, password, finalEnc)
    }

    private fun splitUnescapedSemicolons(input: String): List<String> {
        val tokens = mutableListOf<String>()
        val sb = StringBuilder()
        var escaped = false
        for (ch in input) {
            if (escaped) {
                sb.append('\\').append(ch)
                escaped = false
            } else if (ch == '\\') {
                escaped = true
            } else if (ch == ';') {
                tokens.add(sb.toString())
                sb.setLength(0)
            } else {
                sb.append(ch)
            }
        }
        if (escaped) sb.append('\\')
        tokens.add(sb.toString())
        return tokens
    }

    private fun unescapeWifiValue(value: String): String {
        val sb = StringBuilder()
        var escaped = false
        for (ch in value) {
            if (escaped) {
                sb.append(ch)
                escaped = false
            } else if (ch == '\\') {
                escaped = true
            } else {
                sb.append(ch)
            }
        }
        if (escaped) sb.append('\\')
        return sb.toString()
    }

    private fun parseWifiUriString(raw: String): ParsedWifiConfig? {
        var ssid: String? = null
        var password = ""
        var encType: String? = null

        val content = if (raw.startsWith("WIFI:", ignoreCase = true)) raw.substring(5) else raw
        val parts = splitUnescapedSemicolons(content)
        for (part in parts) {
            val trimmed = part.trim()
            if (trimmed.startsWith("S:", ignoreCase = true)) {
                ssid = unescapeWifiValue(trimmed.substring(2))
            } else if (trimmed.startsWith("P:", ignoreCase = true)) {
                password = unescapeWifiValue(trimmed.substring(2))
            } else if (trimmed.startsWith("T:", ignoreCase = true)) {
                val t = trimmed.substring(2).uppercase()
                encType = when (t) {
                    "WEP" -> "WEP"
                    "NOPASS", "NONE", "OPEN" -> "OPEN"
                    else -> "WPA"
                }
            }
        }
        val resolvedSsid = ssid
        if (resolvedSsid.isNullOrEmpty()) return null
        val finalEnc = encType ?: if (password.isNotEmpty()) "WPA" else "OPEN"
        return ParsedWifiConfig(resolvedSsid, password, finalEnc)
    }

    private fun parseWifiFromNdef(msg: NdefMessage): ParsedWifiConfig? {
        for (record in msg.records) {
            val mimeType = try {
                record.toMimeType()
            } catch (_: Exception) {
                null
            }
            val typeStr = try {
                String(record.type, Charsets.US_ASCII)
            } catch (_: Exception) {
                ""
            }

            if ("application/vnd.wfa.wsc".equals(mimeType, ignoreCase = true) ||
                "application/vnd.wfa.wsc".equals(typeStr, ignoreCase = true)
            ) {
                val config = parseWscPayload(record.payload)
                if (config != null) return config
            }

            val uriStr = try {
                record.toUri()?.toString()
            } catch (_: Exception) {
                null
            }
            if (uriStr != null && uriStr.startsWith("WIFI:", ignoreCase = true)) {
                val config = parseWifiUriString(uriStr)
                if (config != null) return config
            }

            val payload = record.payload
            if (payload != null && payload.isNotEmpty()) {
                val text = try {
                    String(payload, Charsets.UTF_8).trim()
                } catch (_: Exception) {
                    ""
                }
                val wifiIdx = text.indexOf("WIFI:", ignoreCase = true)
                if (wifiIdx >= 0) {
                    val config = parseWifiUriString(text.substring(wifiIdx))
                    if (config != null) return config
                }
            }
        }
        return null
    }

    private fun handleReadTag(tag: Tag) {
        try {
            val ndef = Ndef.get(tag)
            if (ndef != null) {
                ndef.connect()
                val msg = ndef.ndefMessage
                ndef.close()

                if (msg != null && msg.records.isNotEmpty()) {
                    val wifiConfig = parseWifiFromNdef(msg)
                    if (wifiConfig != null) {
                        triggerSuccessVibration()
                        stopNfcSession()
                        emitEvent(
                            mapOf(
                                "event" to "wifi_read",
                                "ssid" to wifiConfig.ssid,
                                "password" to wifiConfig.password,
                                "encType" to wifiConfig.encType
                            )
                        )
                        return
                    }
                }

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
                    stopNfcSession()
                    emitEvent(
                        mapOf(
                            "event" to "url_read",
                            "url" to extractedUrl
                        )
                    )
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
                    stopNfcSession()
                    emitEvent(mapOf("event" to "perm_lock_success"))
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

    private fun handleEraseTag(tag: Tag) {
        val tagId = tag.id
        val now = System.currentTimeMillis()
        if (tagId != null && lastWrittenTagId?.contentEquals(tagId) == true && now - lastWriteTimestamp < 1500L) {
            return
        }

        try {
            val emptyRecord = NdefRecord(NdefRecord.TNF_EMPTY, ByteArray(0), ByteArray(0), ByteArray(0))
            val emptyMessage = NdefMessage(arrayOf(emptyRecord))

            val ndef = Ndef.get(tag)
            if (ndef != null) {
                ndef.connect()
                if (!ndef.isWritable) {
                    ndef.close()
                    notifyNfcError("LOCKED")
                    return
                }
                ndef.writeNdefMessage(emptyMessage)
                ndef.close()
                lastWriteTimestamp = System.currentTimeMillis()
                lastWrittenTagId = tagId?.clone()
                writtenTagsCount++
                triggerSuccessVibration()
                pauseNfcSession()
                emitEvent(
                    mapOf(
                        "event" to "erase_success",
                        "count" to writtenTagsCount,
                        "op" to "ERASE"
                    )
                )
                return
            }

            val formatable = NdefFormatable.get(tag)
            if (formatable != null) {
                formatable.connect()
                formatable.format(emptyMessage)
                formatable.close()
                lastWriteTimestamp = System.currentTimeMillis()
                lastWrittenTagId = tagId?.clone()
                writtenTagsCount++
                triggerSuccessVibration()
                pauseNfcSession()
                emitEvent(
                    mapOf(
                        "event" to "erase_success",
                        "count" to writtenTagsCount,
                        "op" to "ERASE"
                    )
                )
                return
            }

            val nfca = NfcA.get(tag)
            if (nfca != null) {
                nfca.connect()
                val cfg = getNtagConfig(tag, nfca)
                if (cfg != null) {
                    val clearTlvCmd = byteArrayOf(
                        0xA2.toByte(),
                        0x04.toByte(),
                        0x03.toByte(),
                        0x00.toByte(),
                        0xFE.toByte(),
                        0x00.toByte()
                    )
                    val resp1 = nfca.transceive(clearTlvCmd)
                    val clearNextPageCmd = byteArrayOf(
                        0xA2.toByte(),
                        0x05.toByte(),
                        0x00.toByte(),
                        0x00.toByte(),
                        0x00.toByte(),
                        0x00.toByte()
                    )
                    val resp2 = nfca.transceive(clearNextPageCmd)
                    nfca.close()
                    if (resp1 != null && resp2 != null) {
                        lastWriteTimestamp = System.currentTimeMillis()
                        lastWrittenTagId = tagId?.clone()
                        writtenTagsCount++
                        triggerSuccessVibration()
                        pauseNfcSession()
                        emitEvent(
                            mapOf(
                                "event" to "erase_success",
                                "count" to writtenTagsCount,
                                "op" to "ERASE"
                            )
                        )
                        return
                    }
                } else {
                    nfca.close()
                }
            }

            notifyNfcError("UNSUPPORTED")
        } catch (e: Exception) {
            if (isTagLost(e)) {
                notifyNfcError("TAG_LOST")
            } else {
                notifyNfcError("WRITE_FAILED")
            }
        }
    }

    private data class NtagConfig(val auth0Page: Int, val pwdPage: Int, val packPage: Int, val typeName: String)

    private fun getNtagConfig(tag: Tag, nfca: NfcA): NtagConfig? {
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
        } catch (_: Exception) {
            try {
                nfca.close()
                nfca.connect()
            } catch (_: Exception) {
            }
        }

        try {
            val ndef = Ndef.get(tag)
            if (ndef != null) {
                val max = ndef.maxSize
                when {
                    max in 800..920 -> return NtagConfig(227, 229, 230, "NTAG216")
                    max in 450..540 -> return NtagConfig(131, 133, 134, "NTAG215")
                    max in 120..180 -> return NtagConfig(41, 43, 44, "NTAG213")
                }
            }
        } catch (_: Exception) {
            // fallback
        }

        return null
    }

    private fun deriveNfcToolsPasswordBytes(pin: String): ByteArray {
        val md = MessageDigest.getInstance("MD5")
        val hash = md.digest(pin.trim().toByteArray(Charsets.UTF_8))
        return hash.copyOfRange(0, 4)
    }

    private fun deriveLegacyPasswordBytes(pin: String): ByteArray {
        val trimmed = pin.trim()
        if (trimmed.length == 4) {
            return trimmed.toByteArray(Charsets.UTF_8)
        }
        val md = MessageDigest.getInstance("SHA-256")
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
            if (cfg == null) {
                nfca.close()
                notifyNfcError("PWD_UNSUPPORTED")
                return
            }
            val pwdBytes = deriveNfcToolsPasswordBytes(pin)

            var isAlreadyLocked = false
            try {
                val readResp = nfca.transceive(byteArrayOf(0x30.toByte(), cfg.auth0Page.toByte()))
                if (readResp != null && readResp.size >= 4) {
                    val currentAuth0 = readResp[3].toInt() and 0xFF
                    if (currentAuth0 != 0xFF) {
                        isAlreadyLocked = true
                    }
                }
            } catch (_: Exception) {
                isAlreadyLocked = true
            }

            if (isAlreadyLocked) {
                var authSuccess = false
                val authCmd = byteArrayOf(0x1B.toByte(), pwdBytes[0], pwdBytes[1], pwdBytes[2], pwdBytes[3])
                try {
                    val resp = nfca.transceive(authCmd)
                    if (resp != null && resp.size >= 2) authSuccess = true
                } catch (_: Exception) {
                }

                if (!authSuccess) {
                    val legacyPwd = deriveLegacyPasswordBytes(pin)
                    try {
                        nfca.close()
                        nfca.connect()
                        nfca.timeout = 3000
                        val authCmdLegacy = byteArrayOf(0x1B.toByte(), legacyPwd[0], legacyPwd[1], legacyPwd[2], legacyPwd[3])
                        val resp = nfca.transceive(authCmdLegacy)
                        if (resp != null && resp.size >= 2) authSuccess = true
                    } catch (_: Exception) {
                    }
                }

                if (!authSuccess) {
                    nfca.close()
                    notifyNfcError("ALREADY_LOCKED")
                    return
                }
            }

            val writePwdCmd = byteArrayOf(0xA2.toByte(), cfg.pwdPage.toByte(), pwdBytes[0], pwdBytes[1], pwdBytes[2], pwdBytes[3])
            nfca.transceive(writePwdCmd)

            val writePackCmd = byteArrayOf(0xA2.toByte(), cfg.packPage.toByte(), 0x00, 0x00, 0x00, 0x00)
            nfca.transceive(writePackCmd)

            val writeAuth0Cmd = byteArrayOf(0xA2.toByte(), cfg.auth0Page.toByte(), 0x00, 0x00, 0x00, 0x04.toByte())
            nfca.transceive(writeAuth0Cmd)

            nfca.close()
            triggerSuccessVibration()
            stopNfcSession()
            emitEvent(
                mapOf(
                    "event" to "pwd_success",
                    "action" to "LOCKED"
                )
            )
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
            if (cfg == null) {
                nfca.close()
                notifyNfcError("PWD_UNSUPPORTED")
                return
            }

            var isLocked = false
            try {
                val readResp = nfca.transceive(byteArrayOf(0x30.toByte(), cfg.auth0Page.toByte()))
                if (readResp != null && readResp.size >= 4) {
                    val currentAuth0 = readResp[3].toInt() and 0xFF
                    if (currentAuth0 != 0xFF) {
                        isLocked = true
                    }
                }
            } catch (_: Exception) {
                isLocked = true
            }

            if (!isLocked) {
                nfca.close()
                triggerSuccessVibration()
                stopNfcSession()
                emitEvent(
                    mapOf(
                        "event" to "pwd_success",
                        "action" to "ALREADY_UNLOCKED"
                    )
                )
                return
            }

            val md5Pwd = deriveNfcToolsPasswordBytes(pin)
            val legacyPwd = deriveLegacyPasswordBytes(pin)
            var authenticated = false

            try {
                val authCmd1 = byteArrayOf(0x1B.toByte(), md5Pwd[0], md5Pwd[1], md5Pwd[2], md5Pwd[3])
                val resp1 = nfca.transceive(authCmd1)
                if (resp1 != null && resp1.size >= 2) {
                    authenticated = true
                }
            } catch (_: Exception) {
                authenticated = false
            }

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
                } catch (_: Exception) {
                    authenticated = false
                }
            }

            if (authenticated) {
                val disableCmd = byteArrayOf(0xA2.toByte(), cfg.auth0Page.toByte(), 0x00, 0x00, 0x00, 0xFF.toByte())
                nfca.transceive(disableCmd)

                try {
                    val resetPwdCmd = byteArrayOf(
                        0xA2.toByte(), cfg.pwdPage.toByte(),
                        0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte()
                    )
                    nfca.transceive(resetPwdCmd)
                } catch (_: Exception) {
                }

                try {
                    val resetPackCmd = byteArrayOf(0xA2.toByte(), cfg.packPage.toByte(), 0x00, 0x00, 0x00, 0x00)
                    nfca.transceive(resetPackCmd)
                } catch (_: Exception) {
                }

                if (cfg.auth0Page != 41) {
                    try {
                        val p41 = nfca.transceive(byteArrayOf(0x30.toByte(), 41.toByte()))
                        if (p41 != null && (p41[0].toInt() and 0xFF) == 0xFF) {
                            nfca.transceive(byteArrayOf(0xA2.toByte(), 41.toByte(), 0x00, 0x00, 0x00, 0x00))
                        }
                    } catch (_: Exception) {
                    }
                }

                nfca.close()
                triggerSuccessVibration()
                stopNfcSession()
                emitEvent(
                    mapOf(
                        "event" to "pwd_success",
                        "action" to "UNLOCKED"
                    )
                )
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

    private fun getDeviceVibrator(): Vibrator? {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
                vm?.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            }
        } catch (_: Exception) {
            null
        }
    }

    private fun triggerSuccessVibration() {
        try {
            val vibrator = getDeviceVibrator() ?: return
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val timings = longArrayOf(0, 140, 70, 180)
                val amplitudes = intArrayOf(0, 220, 0, 255)
                vibrator.vibrate(VibrationEffect.createWaveform(timings, amplitudes, -1))
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(longArrayOf(0, 140, 70, 180), -1)
            }
        } catch (_: Exception) {
        }
    }

    private fun triggerErrorVibration() {
        try {
            val vibrator = getDeviceVibrator() ?: return
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val timings = longArrayOf(0, 100, 70, 100, 70, 100)
                val amplitudes = intArrayOf(0, 220, 0, 220, 0, 255)
                vibrator.vibrate(VibrationEffect.createWaveform(timings, amplitudes, -1))
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(longArrayOf(0, 100, 70, 100, 70, 100), -1)
            }
        } catch (_: Exception) {
        }
    }

    private fun triggerLightHaptic() {
        try {
            val vibrator = getDeviceVibrator() ?: return
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                vibrator.vibrate(VibrationEffect.createPredefined(VibrationEffect.EFFECT_CLICK))
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createOneShot(18, 120))
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(18)
            }
        } catch (_: Exception) {
        }
    }

    private fun notifyNfcError(errorCode: String) {
        stopNfcSession()
        triggerErrorVibration()
        emitEvent(
            mapOf(
                "event" to "error",
                "code" to errorCode
            )
        )
    }

    private fun saveQrPngBytes(bytes: ByteArray, filename: String): Boolean {
        return try {
            val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size) ?: return false
            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, filename)
                put(MediaStore.MediaColumns.MIME_TYPE, "image/png")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES + "/ReviewLinks")
                    put(MediaStore.MediaColumns.IS_PENDING, 1)
                }
            }

            val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
                ?: return false

            contentResolver.openOutputStream(uri)?.use { outStream ->
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream)
            } ?: return false

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                contentValues.clear()
                contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
                contentResolver.update(uri, contentValues, null, null)
            }
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun handleApkUpdate(downloadUrl: String): Boolean {
        return try {
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
                        } catch (_: Exception) {
                            try {
                                val viewIntent = Intent(DownloadManager.ACTION_VIEW_DOWNLOADS).apply {
                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                startActivity(viewIntent)
                            } catch (_: Exception) {
                            }
                        }
                        try {
                            unregisterReceiver(this)
                        } catch (_: Exception) {
                        }
                    }
                }
            }

            ContextCompat.registerReceiver(
                this,
                receiver,
                IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE),
                ContextCompat.RECEIVER_EXPORTED
            )
            true
        } catch (_: Exception) {
            try {
                val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(downloadUrl)).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                startActivity(browserIntent)
                true
            } catch (_: Exception) {
                false
            }
        }
    }
}
