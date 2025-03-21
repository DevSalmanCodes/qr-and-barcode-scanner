import 'package:hive_flutter/hive_flutter.dart';
part 'qr_model.g.dart';
@HiveType(typeId: 0)
class QRModel {
  @HiveField(0)
  final String value;
  @HiveField(1)
  final String image;
  @HiveField(2)
  final DateTime timestamp;

  QRModel({required this.value, required this.image, required this.timestamp});
}
