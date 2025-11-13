package com.example.sprint4_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.label.ImageLabeling
import com.google.mlkit.vision.label.defaults.ImageLabelerOptions
import java.io.ByteArrayInputStream
import android.graphics.BitmapFactory

class MainActivity : FlutterActivity() {
    private val channel = "com.sprint4/image_labeling"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "labelImage" -> {
                        val args = call.arguments as? Map<*, *>
                        val bytes = args?.get("bytes") as? ByteArray

                        if (bytes == null) {
                            result.error("INVALID_ARGUMENTS", "Missing image bytes", null)
                            return@setMethodCallHandler
                        }

                        labelImage(bytes, result)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun labelImage(bytes: ByteArray, result: MethodChannel.Result) {
        try {
            val inputStream = ByteArrayInputStream(bytes)
            val bitmap = BitmapFactory.decodeStream(inputStream)

            if (bitmap == null) {
                result.error("INVALID_IMAGE", "Could not decode image", null)
                return
            }

            val image = InputImage.fromBitmap(bitmap, 0)
            var labeler = ImageLabeling.getClient(
                ImageLabelerOptions.Builder()
                    .setConfidenceThreshold(0.5f)
                    .build()
            )

            labeler.process(image)
                .addOnSuccessListener { labels ->
                    val labelData = labels.map { label ->
                        mapOf(
                            "text" to label.text,
                            "confidence" to label.confidence,
                            "index" to label.index
                        )
                    }

                    result.success(labelData)
                }
                .addOnFailureListener { error ->
                    result.error("ML_KIT_ERROR", error.localizedMessage, null)
                }
        } catch (exception: Exception) {
            result.error("EXCEPTION", exception.localizedMessage, null)
        }
    }
}