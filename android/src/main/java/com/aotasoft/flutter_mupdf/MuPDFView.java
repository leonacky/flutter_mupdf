package com.aotasoft.flutter_mupdf;

import android.content.Context;
import android.net.Uri;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import com.artifex.sonui.editor.DocumentView;

import java.io.File;
import java.util.Map;

public class MuPDFView implements PlatformView, MethodChannel.MethodCallHandler {
  private final View documentView;
  private final MethodChannel methodChannel;
//  private final LinkHandler linkHandler;

  @SuppressWarnings("unchecked")
  MuPDFView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
    LayoutInflater layoutInflater = LayoutInflater.from(context);
    documentView = layoutInflater.inflate(R.layout.test_view, null);
//    documentView = view.findViewById(R.id.doc_view);
    methodChannel = new MethodChannel(messenger, "plugins.aotasoft.com/mupdf_" + id);
    methodChannel.setMethodCallHandler(this);

//    linkHandler = new PDFLinkHandler(context, pdfView, methodChannel, preventLinkNavigation);

    if (params.get("filePath") != null) {
      String filePath = (String) params.get("filePath");
//      documentView.start(getURI(filePath), 1, true);
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

  }

  @Override
  public View getView() {
    if (documentView == null)
      Log.d("tuandv", "document null");
    return documentView;
  }

  @Override
  public void dispose() {
    methodChannel.setMethodCallHandler(null);
  }

  private Uri getURI(final String uri) {
    Uri parsed = Uri.parse(uri);

    if (parsed.getScheme() == null || parsed.getScheme().isEmpty()) {
      return Uri.fromFile(new File(uri));
    }
    return parsed;
  }
}
