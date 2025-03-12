import 'dart:io';

import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final String result;
  final String path;
  const ResultView({super.key, required this.result, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                result,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Image.file(
                File(path),
                height: 180.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
