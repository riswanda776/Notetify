package com.riswanda.simplenote

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity:FlutterActivity() {
  @Override
  protected fun onCreate(savedInstanceState:Bundle) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}