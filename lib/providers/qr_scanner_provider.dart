import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/utils/pick_image.dart';
import 'package:qr_code_scanner/utils/show_snackBar.dart';
import 'package:qr_code_scanner/views/result_view.dart.dart';

class QRCodeScannerProvider extends ChangeNotifier {
  static final MobileScannerController _scannerController =
      MobileScannerController(
    autoStart: true,
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    returnImage: true,
  );
  MobileScannerController get scannerController => _scannerController;
  bool _isScanning = true;
  bool get isScanning => _isScanning;
  bool _isTorchEnabled = false;
  bool get isTorchEnabled => _isTorchEnabled;
  void setIsScanning(bool value) {
    _isScanning = value;
    notifyListeners();
  }

  void stopScanning() {
    setIsScanning(false);
    _scannerController.stop();
  }

  void startScanning() {
    setIsScanning(true);
    _scannerController.start();
  }

  void toggleTorch() async {
    await _scannerController.toggleTorch();
    _isTorchEnabled = !_isTorchEnabled;
    notifyListeners();
  }

  void analyzeImageFromGallery() async {
    try {
      final image = await pickImageFromGallery();
      if (image == null) return;
      final result = await _scannerController.analyzeImage(image);
      if (result == null || result.barcodes.isEmpty) {
        showSnackBar("No QR Code found");
        return;
      }

      final barcode = result.barcodes.first;
      Get.to(() => ResultView(result: barcode.rawValue!, path: image));
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
