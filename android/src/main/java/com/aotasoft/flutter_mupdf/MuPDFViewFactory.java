package com.aotasoft.flutter_mupdf;

import android.content.Context;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class MuPDFViewFactory extends PlatformViewFactory {
  private final BinaryMessenger messenger;

  public MuPDFViewFactory(BinaryMessenger messenger) {
    super(StandardMessageCodec.INSTANCE);
    this.messenger = messenger;
  }

  @Override
  public PlatformView create(Context context, int viewId, @Nullable Object args) {
    Map<String, Object> params = (Map<String, Object>) args;
    return new MuPDFView(context, messenger, viewId, params);
  }
}
