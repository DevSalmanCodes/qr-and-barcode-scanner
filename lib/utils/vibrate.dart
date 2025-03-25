import 'package:vibration/vibration.dart';

void vibrate() async {
  final hasVibrator = await Vibration.hasVibrator();
  if (!hasVibrator) return;
  await Vibration.vibrate(duration: 200);
}
