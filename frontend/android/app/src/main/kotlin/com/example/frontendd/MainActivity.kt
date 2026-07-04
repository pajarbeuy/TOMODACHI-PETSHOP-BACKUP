package com.example.frontendd

import android.content.ContentValues
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.pdf.PdfDocument
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.text.Html
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val exportChannel = "tomodachi/report_exporter"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, exportChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveToDownloads" -> {
                    val fileName = call.argument<String>("fileName")
                    val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"
                    val content = call.argument<String>("content")

                    if (fileName.isNullOrBlank() || content == null) {
                        result.error("INVALID_ARGS", "Nama file atau isi laporan tidak valid.", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val savedPath = saveTextToDownloads(fileName, mimeType, content)
                        result.success(savedPath)
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", e.message ?: "Gagal menyimpan laporan.", null)
                    }
                }
                "savePdfToDownloads" -> {
                    val fileName = call.argument<String>("fileName")
                    val title = call.argument<String>("title") ?: "Laporan Penjualan Tomodachi"
                    val htmlContent = call.argument<String>("htmlContent")

                    if (fileName.isNullOrBlank() || htmlContent == null) {
                        result.error("INVALID_ARGS", "Nama file atau isi laporan PDF tidak valid.", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val pdfBytes = createPdfBytes(title, htmlContent)
                        val savedPath = saveBytesToDownloads(fileName, "application/pdf", pdfBytes)
                        result.success(savedPath)
                    } catch (e: Exception) {
                        result.error("PDF_SAVE_FAILED", e.message ?: "Gagal menyimpan PDF.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun saveTextToDownloads(fileName: String, mimeType: String, content: String): String {
        return saveBytesToDownloads(fileName, mimeType, content.toByteArray(Charsets.UTF_8))
    }

    private fun saveBytesToDownloads(fileName: String, mimeType: String, bytes: ByteArray): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = applicationContext.contentResolver
            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                put(MediaStore.MediaColumns.IS_PENDING, 1)
            }

            val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IllegalStateException("Tidak bisa membuat file di folder Download.")

            resolver.openOutputStream(uri)?.use { output ->
                output.write(bytes)
                output.flush()
            } ?: throw IllegalStateException("Tidak bisa menulis file laporan.")

            values.clear()
            values.put(MediaStore.MediaColumns.IS_PENDING, 0)
            resolver.update(uri, values, null, null)

            return "Download/$fileName"
        }

        val downloads = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        if (!downloads.exists()) {
            downloads.mkdirs()
        }

        val file = File(downloads, fileName)
        FileOutputStream(file).use { output ->
            output.write(bytes)
            output.flush()
        }

        return file.absolutePath
    }

    private fun createPdfBytes(title: String, htmlContent: String): ByteArray {
        val document = PdfDocument()
        val pageWidth = 595
        val pageHeight = 842
        val margin = 36f
        val contentWidth = pageWidth - (margin * 2)
        val lineHeight = 15f
        val titleHeight = 28f

        val titlePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.rgb(61, 35, 20)
            textSize = 18f
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
        }
        val bodyPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.rgb(61, 35, 20)
            textSize = 10.5f
        }

        val plainText = htmlToPlainText(htmlContent)
        val lines = plainText
            .lineSequence()
            .flatMap { wrapLine(it, bodyPaint, contentWidth).asSequence() }
            .toList()

        var pageNumber = 1
        var page = document.startPage(PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNumber).create())
        var canvas = page.canvas
        canvas.drawColor(Color.WHITE)
        canvas.drawText(title, margin, margin + 4f, titlePaint)
        var y = margin + titleHeight

        for (line in lines) {
            if (y > pageHeight - margin) {
                document.finishPage(page)
                pageNumber += 1
                page = document.startPage(PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNumber).create())
                canvas = page.canvas
                canvas.drawColor(Color.WHITE)
                y = margin
            }

            canvas.drawText(line, margin, y, bodyPaint)
            y += lineHeight
        }

        document.finishPage(page)

        val output = ByteArrayOutputStream()
        document.writeTo(output)
        document.close()
        return output.toByteArray()
    }

    private fun htmlToPlainText(htmlContent: String): String {
        val withBreaks = htmlContent
            .replace(Regex("(?i)<br\\s*/?>"), "\n")
            .replace(Regex("(?i)</(p|div|h1|h2|tr|table)>"), "\n")
            .replace(Regex("(?i)</t[dh]>"), "    ")

        val spanned = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            Html.fromHtml(withBreaks, Html.FROM_HTML_MODE_LEGACY)
        } else {
            @Suppress("DEPRECATION")
            Html.fromHtml(withBreaks)
        }

        return spanned
            .toString()
            .lines()
            .map { it.trim() }
            .filter { it.isNotEmpty() }
            .joinToString("\n")
    }

    private fun wrapLine(line: String, paint: Paint, maxWidth: Float): List<String> {
        if (line.isBlank()) return listOf("")

        val result = mutableListOf<String>()
        var current = ""

        for (word in line.split(Regex("\\s+"))) {
            val candidate = if (current.isEmpty()) word else "$current $word"
            if (paint.measureText(candidate) <= maxWidth) {
                current = candidate
            } else {
                if (current.isNotEmpty()) {
                    result.add(current)
                }
                current = word
            }
        }

        if (current.isNotEmpty()) {
            result.add(current)
        }

        return result
    }
}
