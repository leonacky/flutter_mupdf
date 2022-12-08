import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

enum FitPolicy { WIDTH, HEIGHT, BOTH }

typedef PDFViewCreatedCallback = void Function(MuPDFController controller);
typedef RenderCallback = void Function(int? pages);
typedef PageChangedCallback = void Function(int? page, int? total);
typedef ErrorCallback = void Function(dynamic error);
typedef PageErrorCallback = void Function(int? page, dynamic error);
typedef LinkHandlerCallback = void Function(String? uri);

class MuPDFView extends StatefulWidget {
  const MuPDFView({
    Key? key,
    this.filePath,
    this.pdfData,
    this.onViewCreated,
    this.onRender,
    this.onPageChanged,
    this.onError,
    this.onPageError,
    this.onLinkHandler,
    this.gestureRecognizers,
    this.enableSwipe = true,
    this.swipeHorizontal = false,
    this.password,
    this.nightMode = false,
    this.autoSpacing = true,
    this.pageFling = true,
    this.pageSnap = true,
    this.fitEachPage = true,
    this.defaultPage = 0,
    this.fitPolicy = FitPolicy.WIDTH,
    this.preventLinkNavigation = false,
  })
      : assert(filePath != null || pdfData != null),
        super(key: key);

  /// If not null invoked once the web view is created.
  final PDFViewCreatedCallback? onViewCreated;
  final RenderCallback? onRender;
  final PageChangedCallback? onPageChanged;
  final ErrorCallback? onError;
  final PageErrorCallback? onPageError;
  final LinkHandlerCallback? onLinkHandler;

  /// Which gestures should be consumed by the pdf view.
  ///
  /// It is possible for other gesture recognizers to be competing with the pdf view on pointer
  /// events, e.g if the pdf view is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The pdf view will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the pdf view will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  /// The initial URL to load.
  final String? filePath;
  final Uint8List? pdfData;

  final bool enableSwipe;
  final bool swipeHorizontal;
  final String? password;
  final bool nightMode;
  final bool autoSpacing;
  final bool pageFling;
  final bool pageSnap;
  final int defaultPage;
  final FitPolicy fitPolicy;
  final bool fitEachPage;
  final bool preventLinkNavigation;

  @override
  State<MuPDFView> createState() => _MuPDFViewState();
}

class _MuPDFViewState extends State<MuPDFView> {
  final Completer<MuPDFController> _controller =
  Completer<MuPDFController>();

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformViewLink(
        viewType: 'plugins.aotasoft.com/mupdf',
        surfaceFactory: (
          BuildContext context,
          PlatformViewController controller,
        ) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            // gestureRecognizers: widget.gestureRecognizers ??
            //     const <Factory<OneSequenceGestureRecognizer>>{},
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: 'plugins.aotasoft.com/mupdf',
            layoutDirection: TextDirection.rtl,
            creationParams: _CreationParams.fromWidget(widget).toMap(),
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener((int id) {
              _onPlatformViewCreated(id);
            })
            ..create();
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.endigo.io/pdfview',
        onPlatformViewCreated: _onPlatformViewCreated,
        // gestureRecognizers: widget.gestureRecognizers,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the pdfview_flutter plugin');
  }

  void _onPlatformViewCreated(int id) {
    final MuPDFController controller = MuPDFController._(id, widget);
    _controller.complete(controller);
    if (widget.onViewCreated != null) {
      widget.onViewCreated!(controller);
    }
  }
}

class _CreationParams {
  _CreationParams({
    this.filePath,
    this.pdfData,
    this.settings,
  });

  static _CreationParams fromWidget(MuPDFView widget) {
    return _CreationParams(
      filePath: widget.filePath,
      pdfData: widget.pdfData,
      settings: _PDFViewSettings.fromWidget(widget),
    );
  }

  final String? filePath;
  final Uint8List? pdfData;

  final _PDFViewSettings? settings;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> params = {
      'filePath': filePath,
      'pdfData': pdfData,
    };

    params.addAll(settings!.toMap());

    return params;
  }
}

class _PDFViewSettings {
  _PDFViewSettings(
      {this.enableSwipe,
      this.swipeHorizontal,
      this.password,
      this.nightMode,
      this.autoSpacing,
      this.pageFling,
      this.pageSnap,
      this.defaultPage,
      this.fitPolicy,
      this.fitEachPage,
      this.preventLinkNavigation});

  static _PDFViewSettings fromWidget(MuPDFView widget) {
    return _PDFViewSettings(
        enableSwipe: widget.enableSwipe,
        swipeHorizontal: widget.swipeHorizontal,
        password: widget.password,
        nightMode: widget.nightMode,
        autoSpacing: widget.autoSpacing,
        pageFling: widget.pageFling,
        pageSnap: widget.pageSnap,
        defaultPage: widget.defaultPage,
        fitPolicy: widget.fitPolicy,
        preventLinkNavigation: widget.preventLinkNavigation);
  }

  final bool? enableSwipe;
  final bool? swipeHorizontal;
  final String? password;
  final bool? nightMode;
  final bool? autoSpacing;
  final bool? pageFling;
  final bool? pageSnap;
  final int? defaultPage;
  final FitPolicy? fitPolicy;
  final bool? fitEachPage;
  final bool? preventLinkNavigation;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enableSwipe': enableSwipe,
      'swipeHorizontal': swipeHorizontal,
      'password': password,
      'nightMode': nightMode,
      'autoSpacing': autoSpacing,
      'pageFling': pageFling,
      'pageSnap': pageSnap,
      'defaultPage': defaultPage,
      'fitPolicy': fitPolicy.toString(),
      'fitEachPage': fitEachPage,
      'preventLinkNavigation': preventLinkNavigation
    };
  }

  Map<String, dynamic> updatesMap(_PDFViewSettings newSettings) {
    final Map<String, dynamic> updates = <String, dynamic>{};
    if (enableSwipe != newSettings.enableSwipe) {
      updates['enableSwipe'] = newSettings.enableSwipe;
    }
    if (pageFling != newSettings.pageFling) {
      updates['pageFling'] = newSettings.pageFling;
    }
    if (pageSnap != newSettings.pageSnap) {
      updates['pageSnap'] = newSettings.pageSnap;
    }
    if (preventLinkNavigation != newSettings.preventLinkNavigation) {
      updates['preventLinkNavigation'] = newSettings.preventLinkNavigation;
    }
    return updates;
  }
}

class MuPDFController {
  MuPDFController._(
    int id,
    this._widget,
  ) : _channel = MethodChannel('plugins.aotasoft.com/mupdf_$id') {
    _settings = _PDFViewSettings.fromWidget(_widget);
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final MethodChannel _channel;

  late _PDFViewSettings _settings;

  final MuPDFView _widget;

  Future<String?> getPlatformVersion() {
    return _channel.invokeMethod('method');
  }

  Future<bool?> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onRender':
        if (_widget.onRender != null) {
          _widget.onRender!(call.arguments['pages']);
        }
        return null;
      case 'onPageChanged':
        if (_widget.onPageChanged != null) {
          _widget.onPageChanged!(
              call.arguments['page'], call.arguments['total']);
        }
        return null;
      case 'onError':
        if (_widget.onError != null) {
          _widget.onError!(call.arguments['error']);
        }
        return null;
      case 'onPageError':
        if (_widget.onPageError != null) {
          _widget.onPageError!(call.arguments['page'], call.arguments['error']);
        }
        return null;
      case 'onLinkHandler':
        if (_widget.onLinkHandler != null) {
          _widget.onLinkHandler!(call.arguments);
        }
        return null;
    }
    throw MissingPluginException(
        '${call.method} was invoked but has no handler');
  }
}
