package com.aotasoft.flutter_mupdf;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class FlutterMupdfPlugin implements FlutterPlugin {
  /**
   * Plugin registration.
   */
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    binding
        .getPlatformViewRegistry()
        .registerViewFactory("plugins.aotasoft.com/mupdf", new MuPDFViewFactory(binding.getBinaryMessenger()));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
