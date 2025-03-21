import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/providers/qr_scanner_provider.dart';

void navigateTo(BuildContext context, Widget page) {
  final provider = context.read<QRCodeScannerProvider>();
  provider.stopScanning();
  Get.to(() => page)!.then((_) => provider.startScanning());
}
