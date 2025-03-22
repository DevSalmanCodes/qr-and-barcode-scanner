import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/constants/text_style.dart';
import 'package:qr_code_scanner/utils/show_snackbar.dart';

class ResultView extends StatelessWidget {
  final String result;
  final String path;
  const ResultView({super.key, required this.result, required this.path});

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text))
        .then((_) => showSnackBar('Copied to clipboard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(result,
                  style:
                      textStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 15.0,
              ),
              Image.file(
                File(path),
                height: 180.0,
              ),
              const SizedBox(
                height: 15.0,
              ),
              IconButton(
                  onPressed: () => _copyToClipboard(result),
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.blue,
                    size: 40.0,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
