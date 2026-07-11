package com.example.frontendd

import android.content.ContentValues
import android.graphics.Color
import android.graphics.pdf.PdfDocument
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.view.View
import android.view.ViewGroup
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import kotlin.math.ceil
import kotlin.math.max

class MainActivity : FlutterActivity() {
    private val exportChannel = "tomodachi/report_exporter"
    private val pdfPageWidth = 595
    private val pdfPageHeight = 842
    private val pdfPageMargin = 51
    private val pdfRenderWidth = 794

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
                    val htmlContent = call.argument<String>("htmlContent")

                    if (fileName.isNullOrBlank() || htmlContent == null) {
                        result.error("INVALID_ARGS", "Nama file atau isi laporan PDF tidak valid.", null)
                        return@setMethodCallHandler
                    }

                    saveHtmlPdfToDownloads(fileName, htmlContent, result)
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

    private fun saveHtmlPdfToDownloads(
        fileName: String,
        htmlContent: String,
        result: MethodChannel.Result
    ) {
        runOnUiThread {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                WebView.enableSlowWholeDocumentDraw()
            }
            val webView = WebView(this)
            var completed = false

            fun cleanup() {
                (webView.parent as? ViewGroup)?.removeView(webView)
                webView.destroy()
            }

            fun finishWithError(code: String, message: String, details: Throwable? = null) {
                if (completed) return
                completed = true
                cleanup()
                result.error(code, message, details?.message)
            }

            fun finishWithSuccess(path: String) {
                if (completed) return
                completed = true
                cleanup()
                result.success(path)
            }

            webView.settings.javaScriptEnabled = false
            webView.settings.loadWithOverviewMode = false
            webView.settings.useWideViewPort = true
            webView.setBackgroundColor(Color.WHITE)
            webView.isVerticalScrollBarEnabled = false
            webView.isHorizontalScrollBarEnabled = false
            webView.setInitialScale(100)
            webView.webViewClient = object : WebViewClient() {
                override fun onPageFinished(view: WebView, url: String?) {
                    fun writePdf() {
                        view.postDelayed({
                            try {
                                writeWebViewPdf(view, fileName, ::finishWithSuccess, ::finishWithError)
                            } catch (e: Exception) {
                                finishWithError("PDF_SAVE_FAILED", e.message ?: "Gagal menyimpan PDF.", e)
                            }
                        }, 500)
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        view.postVisualStateCallback(
                            0,
                            object : WebView.VisualStateCallback() {
                                override fun onComplete(requestId: Long) {
                                    writePdf()
                                }
                            }
                        )
                    } else {
                        writePdf()
                    }
                }
            }

            try {
                val layoutParams = ViewGroup.LayoutParams(pdfRenderWidth, 1)
                addContentView(webView, layoutParams)
                webView.measure(
                    View.MeasureSpec.makeMeasureSpec(pdfRenderWidth, View.MeasureSpec.EXACTLY),
                    View.MeasureSpec.makeMeasureSpec(1, View.MeasureSpec.EXACTLY)
                )
                webView.layout(0, 0, pdfRenderWidth, 1)
                webView.postDelayed({
                    finishWithError(
                        "PDF_RENDER_TIMEOUT",
                        "Render PDF terlalu lama. Coba export ulang."
                    )
                }, 15000)
                webView.loadDataWithBaseURL(null, desktopHtml(htmlContent), "text/html", "UTF-8", null)
            } catch (e: Exception) {
                finishWithError("PDF_RENDER_FAILED", e.message ?: "Gagal merender laporan PDF.", e)
            }
        }
    }

    private fun desktopHtml(htmlContent: String): String {
        val viewport = "<meta name=\"viewport\" content=\"width=$pdfRenderWidth, initial-scale=1.0\">"
        return if (htmlContent.contains("<head>", ignoreCase = true)) {
            htmlContent.replace(Regex("(?i)<head>"), "<head>$viewport")
        } else {
            "$viewport$htmlContent"
        }
    }

    private fun writeWebViewPdf(
        webView: WebView,
        fileName: String,
        onSuccess: (String) -> Unit,
        onError: (String, String, Throwable?) -> Unit
    ) {
        val pageWidth = pdfPageWidth
        val pageHeight = pdfPageHeight
        val margin = pdfPageMargin
        val contentWidth = pageWidth - (margin * 2)
        val contentHeightPerPage = pageHeight - (margin * 2)
        val renderWidth = pdfRenderWidth
        val scale = contentWidth.toFloat() / renderWidth.toFloat()
        val contentHeightPerPageInWebView = contentHeightPerPage.toFloat() / scale
        val exactWidth = View.MeasureSpec.makeMeasureSpec(renderWidth, View.MeasureSpec.EXACTLY)
        val freeHeight = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED)

        webView.measure(exactWidth, freeHeight)
        val measuredHeight = webView.measuredHeight
        val contentHeight = max(
            max(measuredHeight, webView.contentHeight),
            ceil(contentHeightPerPageInWebView).toInt()
        )
        webView.layout(0, 0, renderWidth, contentHeight)

        val document = PdfDocument()
        try {
            val pageCount = max(
                1,
                ceil(contentHeight.toDouble() / contentHeightPerPageInWebView.toDouble()).toInt()
            )
            for (pageIndex in 0 until pageCount) {
                val page = document.startPage(
                    PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageIndex + 1).create()
                )
                val canvas = page.canvas
                canvas.drawColor(Color.WHITE)
                canvas.save()
                canvas.clipRect(margin, margin, pageWidth - margin, pageHeight - margin)
                canvas.translate(margin.toFloat(), margin.toFloat())
                canvas.scale(scale, scale)
                canvas.translate(0f, -(pageIndex * contentHeightPerPageInWebView))
                webView.draw(canvas)
                canvas.restore()
                document.finishPage(page)
            }

            val output = ByteArrayOutputStream()
            document.writeTo(output)
            val savedPath = saveBytesToDownloads(fileName, "application/pdf", output.toByteArray())
            onSuccess(savedPath)
        } catch (e: Exception) {
            onError("PDF_SAVE_FAILED", e.message ?: "Gagal menyimpan PDF.", e)
        } finally {
            document.close()
        }
    }
}
