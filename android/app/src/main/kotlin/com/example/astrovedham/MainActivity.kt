package com.example.astrovedham

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.astrovedham.app/media_store"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveToDownloads") {
                val bytes = call.argument<ByteArray>("bytes")
                val fileName = call.argument<String>("fileName")

                if (bytes == null || fileName == null) {
                    result.error("INVALID_ARGS", "Bytes or fileName is null", null)
                    return@setMethodCallHandler
                }

                try {
                    val savedPath = savePdfToDownloads(bytes, fileName)
                    if (savedPath != null) {
                        result.success(savedPath)
                    } else {
                        result.error("SAVE_FAILED", "Failed to save file to Downloads", null)
                    }
                } catch (e: Exception) {
                    result.error("EXCEPTION", e.localizedMessage, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun savePdfToDownloads(bytes: ByteArray, fileName: String): String? {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // Android 10 (API 29) and higher - Use MediaStore.Downloads
            val resolver = context.contentResolver
            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.MIME_TYPE, "application/pdf")
                put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
            }

            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
                ?: return null

            resolver.openOutputStream(uri)?.use { outputStream ->
                outputStream.write(bytes)
                outputStream.flush()
            }

            return uri.toString()
        } else {
            // Android 9 (API 28) and lower - Direct File write to public Downloads directory
            val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            if (!downloadsDir.exists()) {
                downloadsDir.mkdirs()
            }

            var destFile = File(downloadsDir, fileName)
            if (destFile.exists()) {
                val nameWithoutExt = if (fileName.contains(".")) fileName.substringBeforeLast(".") else fileName
                val ext = if (fileName.contains(".")) ".${fileName.substringAfterLast(".")}" else ""
                var count = 1
                while (destFile.exists()) {
                    destFile = File(downloadsDir, "$nameWithoutExt ($count)$ext")
                    count++
                }
            }

            FileOutputStream(destFile).use { outputStream ->
                outputStream.write(bytes)
                outputStream.flush()
            }

            return destFile.absolutePath
        }
    }
}
