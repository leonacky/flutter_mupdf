package com.aotasoft.flutter_mupdf;

import android.content.Context;
import android.net.Uri;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import com.artifex.sonui.editor.DocPdfView;
import com.artifex.sonui.editor.DocumentView;
//import com.github.barteksc.pdfviewer.PDFView;

import java.io.File;
import java.util.Map;

public class MuPDFView implements PlatformView, MethodChannel.MethodCallHandler {
  private final ViewGroup mainView;
    private final DocumentView documentView;
//  private final PDFView documentView;
  private final MethodChannel methodChannel;
//  private final LinkHandler linkHandler;

  @SuppressWarnings("unchecked")
  MuPDFView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
    LayoutInflater layoutInflater = LayoutInflater.from(context);
    mainView = (ViewGroup) layoutInflater.inflate(R.layout.document_view, null);
    documentView = mainView.findViewById(R.id.doc_view);
    methodChannel = new MethodChannel(messenger, "plugins.aotasoft.com/mupdf_" + id);
    methodChannel.setMethodCallHandler(this);

//    linkHandler = new PDFLinkHandler(context, pdfView, methodChannel, preventLinkNavigation);

    if (params.get("filePath") != null) {
      String filePath = (String) params.get("filePath");
      Log.d("tuandv", getURI(filePath).toString());
      documentView.start(getURI(filePath), 0, false);
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

  }

  @Override
  public View getView() {
    if (mainView == null)
      Log.d("tuandv", "document null");
    return mainView;
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
