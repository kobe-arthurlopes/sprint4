package com.example.sprint4_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var methodChannelType: MethodChannelType? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        methodChannelType = MethodChannelType.IMAGE_LABELING
        methodChannelType?.setMethodCallHandler(binaryMessenger)
    }
}