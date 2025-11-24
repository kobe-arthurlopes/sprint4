package com.example.sprint4_app

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

enum class MethodChannelType(
    val propertyName: String,
    val methodName: String
) {
    IMAGE_LABELING("image_labeling", "labelImage");

    private fun channel(binaryMessenger: BinaryMessenger): MethodChannel {
        val channelName = "com.sprint4/$propertyName"
        return MethodChannel(binaryMessenger, channelName)
    }

    fun setMethodCallHandler(binaryMessenger: BinaryMessenger) {
        val channel = channel(binaryMessenger)

        channel.setMethodCallHandler { call, result ->
            handleCall(call, result)
        }
    }

    private fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != methodName) {
            result.notImplemented()
            return
        }

        when (this) {
            IMAGE_LABELING -> {
                val args = call.arguments as? Map<*, *>
                val bytes = args?.get("bytes") as? ByteArray

                if (bytes == null) {
                    result.error("INVALID_ARGUMENTS", "Missing image bytes", null)
                    return
                }

                ImageLabelingService.labelImage(bytes, result)
            }
        }
    }
}