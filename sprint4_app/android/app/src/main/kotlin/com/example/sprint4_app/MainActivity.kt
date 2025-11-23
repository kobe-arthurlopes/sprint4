package com.example.sprint4_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var methodChannelType: MethodChannelType? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannelType = MethodChannelType.IMAGE_LABELING
        methodChannelType?.setMethodCallHandler(flutterEngine.dartExecutor.binaryMessenger)
    }
}