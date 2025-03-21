import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Crop QR Code from full image
Future<String> saveCroppedQRImage(
    Uint8List fullImage, List<Offset> corners) async {
  // Convert Uint8List to Image
  img.Image? original = img.decodeImage(fullImage);
  if (original == null) return '';

  double minX = corners.map((e) => e.dx).reduce((a, b) => a < b ? a : b);
  double minY = corners.map((e) => e.dy).reduce((a, b) => a < b ? a : b);
  double maxX = corners.map((e) => e.dx).reduce((a, b) => a > b ? a : b);
  double maxY = corners.map((e) => e.dy).reduce((a, b) => a > b ? a : b);

  int x = minX.toInt();
  int y = minY.toInt();
  int width = (maxX - minX).toInt();
  int height = (maxY - minY).toInt();

  // Ensure cropping area is valid
  if (x < 0 || y < 0 || width <= 0 || height <= 0) return '';

  // Crop only the QR Code area
  img.Image cropped =
      img.copyCrop(original, x: x, y: y, width: width, height: height);

  // Convert back to Uint8List
  Uint8List croppedBytes = Uint8List.fromList(img.encodePng(cropped));

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/${DateTime.now()}.png');
  await file.writeAsBytes(croppedBytes);

  return file.path;
}
