import 'package:file_picker/file_picker.dart';
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
  String? pdfData;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    browseFile();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  Future<void> browseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      pdfData = result.files.single.path;
      loaded = true;
      await Future<void>.delayed(const Duration(seconds: 1));
      setState(() {

      });
    } else {
      // User canceled the picker
    }
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
                child: MuPDFView(filePath: pdfData),
              )
            : Container(
                color: Colors.red,
              ),
      ),
    );
  }
}
