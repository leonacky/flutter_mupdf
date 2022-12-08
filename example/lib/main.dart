import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mupdf/flutter_mupdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loaded = false;
  Uint8List? pdfData;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    readPdf();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  Future<void> readPdf() async {
    print('tuandv 1');
    await Future<void>.delayed(const Duration(seconds: 10));
    ByteData bd = await rootBundle.load('assets/sample.pdf');
    pdfData = bd.buffer.asUint8List();
    loaded = true;
    setState(() {

    });
    print('tuandv 2');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app 1'),
        ),
        body: loaded && pdfData != null
            ? Container(
                color: Colors.green,
                child: MuPDFView(pdfData: pdfData),
              )
            : Container(
                color: Colors.red,
              ),
      ),
    );
  }
}
