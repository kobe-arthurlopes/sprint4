package com.example.sprint4_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var methodChannelService: MethodChannelService? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannelService = MethodChannelService(flutterEngine.dartExecutor.binaryMessenger)
        methodChannelService?.setMethodCallHandler()
    }
}