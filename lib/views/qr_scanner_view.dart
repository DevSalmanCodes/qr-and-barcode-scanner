import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/providers/history_provider.dart';
import 'package:qr_code_scanner/providers/qr_scanner_provider.dart';
import 'package:qr_code_scanner/utils/navigation_helper.dart';
import 'package:qr_code_scanner/utils/show_snackbar.dart';
import 'package:qr_code_scanner/views/history_view.dart';
import 'package:qr_code_scanner/widgets/drawer_tile.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

import '../utils/crop_qr_image.dart';
import '../utils/play_beep.dart';
import 'result_view.dart.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Animation<double> _opacityAnimation;
  late AnimationController _opacityAnimationController;

  @override
  void initState() {
    super.initState();
    _opacityAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.8)
        .animate(_opacityAnimationController);
  }

  @override
  void didChangeDependencies() {
    Provider.of<QRCodeScannerProvider>(context, listen: false)
        .scannerController
        .stop();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _opacityAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanWindow = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.6,
      size.height * 0.4,
    );
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<QRCodeScannerProvider>(
        builder: (context, provider, child) => Stack(
          children: [
            MobileScanner(
              scanWindow: scanWindow,
              fit: BoxFit.cover,
              controller: provider.scannerController,
              onDetect: onDetect,
            ),
            QRScannerOverlay(
              borderColor: Colors.blue,
              borderStrokeWidth: 8,
              scanAreaSize: Size(size.width * 0.75, size.height * 0.35),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) => Container(
                  color: Colors.red.withOpacity(_opacityAnimation.value),
                  width: size.width * 0.75,
                  height: 2,
                ),
              ),
            ),
            Positioned(
                top: 40,
                left: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (!_scaffoldKey.currentState!.isDrawerOpen) {
                            _scaffoldKey.currentState!.openDrawer();
                          }
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () =>
                            provider.analyzeImageFromGallery(context,mounted),
                        icon: const Icon(
                          Icons.image,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () => provider.toggleTorch(),
                        icon: Icon(
                          provider.isTorchEnabled
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () => provider.switchCamera(),
                        icon: const Icon(
                          Icons.flip_camera_android_outlined,
                          color: Colors.white,
                        ))
                  ],
                ))
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade900,
        child: ListView(
          children: [
            const DrawerTile(icon: Icons.create, title: 'Create QR'),
            DrawerTile(
                icon: Icons.history,
                title: 'History',
                onTap: () {
                  navigateTo(context, const HistoryView());
                }),
            const DrawerTile(icon: Icons.settings, title: 'Settings')
          ],
        ),
      ),
    );
  }

  void onDetect(BarcodeCapture? capture) async {
    final qrProvider = context.read<QRCodeScannerProvider>();
    if (capture == null || capture.barcodes.isEmpty) return;
    final barcode = capture.barcodes.first;

    if (barcode.rawValue == null || barcode.rawValue!.isEmpty) {
      return showSnackBar("No QR Code found");
    }

    if (capture.image == null || barcode.corners.isEmpty) {
      return showSnackBar("Could not capture image properly");
    }
    final croppedPath =
        await saveCroppedQRImage(capture.image!, barcode.corners);
    playBeepSound();
    context.read<HistoryProvider>().addHistory(barcode.rawValue!, croppedPath);
    qrProvider.stopScanning();
    Get.to(() => ResultView(result: barcode.rawValue!, path: croppedPath))!
        .then((_) => qrProvider.startScanning());
  }
}
