import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
void playBeepSound() async {
  try {
    await _audioPlayer.play(AssetSource('beep.mp3'), volume: 0.1);
  } catch (e) {
    debugPrint('Error playing beep sound: $e');
  }
}
