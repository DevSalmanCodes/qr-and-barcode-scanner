import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/constants/text_style.dart';
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
        body: Consumer<HistoryProvider>(
          builder: (context, provider, child) => ListView.builder(
            itemCount: historyProvider.history.length,
            itemBuilder: (context, index) {
              final singleHistory = historyProvider.history[index];
              return ListTile(
                leading: Image.file(File(singleHistory.image)),
                title: Text(
                  singleHistory.value,
                  style: textStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(singleHistory.timestamp.toString(),
                    style: textStyle()),
                trailing: PopupMenuButton(
                    color: Colors.grey.shade900,
                    iconColor: Colors.white,
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onTap: () => provider.deleteHistory(index),
                          )
                        ]),
              );
            },
          ),
        ));
  }
}
