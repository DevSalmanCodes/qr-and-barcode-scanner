import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/providers/settings_provider.dart';
import 'package:qr_code_scanner/utils/navigation_helper.dart';
import 'package:qr_code_scanner/utils/pick_image.dart';
import 'package:qr_code_scanner/utils/play_beep.dart';
import 'package:qr_code_scanner/utils/show_snackBar.dart';
import 'package:qr_code_scanner/utils/vibrate.dart';
import 'package:qr_code_scanner/views/result_view.dart.dart';

import 'history_provider.dart';

class QRCodeScannerProvider extends ChangeNotifier {
  late MobileScannerController _scannerController;
  QRCodeScannerProvider() {
    _scannerController = MobileScannerController(
      autoStart: true,
      facing: CameraFacing.back,
      returnImage: true,
    );
  }

  MobileScannerController get scannerController => _scannerController;
  bool _isTorchEnabled = false;
  bool get isTorchEnabled => _isTorchEnabled;

  void stopScanning() {
    _scannerController.stop();
  }

  void startScanning() {
    _scannerController.start();
  }

  void toggleTorch() async {
    await _scannerController.toggleTorch();
    _isTorchEnabled = !_isTorchEnabled;
    notifyListeners();
  }

  void analyzeImageFromGallery(BuildContext context, bool mounted) async {
    final settingsProvider = context.read<SettingsProvider>();
    try {
      final image = await pickImageFromGallery();
      if (image == null) return;
      final result = await _scannerController.analyzeImage(image);
      if (result == null || result.barcodes.isEmpty) {
        showSnackBar("No QR Code found");
        return;
      }

      final barcode = result.barcodes.first;

      if (settingsProvider.vibrate == true) {
        vibrate();
      }
      if (settingsProvider.beep == true) {
        playBeepSound();
      }
      if (!mounted) return;
      context.read<HistoryProvider>().addHistory(barcode.rawValue!, image);
      navigateTo(
          context,
          ResultView(
            result: barcode.rawValue!,
            path: image,
          ));
    } catch (e) {
      showSnackBar("Error: $e");
      return;
    }
  }

  void switchCamera() async {
    await _scannerController.switchCamera();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _scannerController.stop();
    super.dispose();
  }
}
