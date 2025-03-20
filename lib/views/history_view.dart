import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/providers/history_provider.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('History'),
        ),
        body: ListView.builder(
          itemCount: historyProvider.history.length,
          itemBuilder: (context, index) {
            final singleHistory = historyProvider.history[index];
            return ListTile(
              leading: Image.file(File(singleHistory.image)),
              title: Text(singleHistory.value),
              subtitle: Text(singleHistory.timestamp.toString()),
            );
          },
        ));
  }
}
