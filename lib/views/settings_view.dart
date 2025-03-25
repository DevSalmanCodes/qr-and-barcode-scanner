import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/constants/text_style.dart';
import 'package:qr_code_scanner/providers/settings_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Consumer<SettingsProvider>(
          builder: (context, provider, child) => Column(
            children: [
              _buildCheckBoxListTile(
                  'Beep', provider.toggleBeep, provider.beep),
              _buildCheckBoxListTile(
                  'Vibrate', provider.toggleVibrate, provider.vibrate),
            ],
          ),
        ),
      ),
    );
  }

  CheckboxListTile _buildCheckBoxListTile(
      String title, void Function(bool?)? onChanged, bool? value) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: textStyle(),
      ),
    );
  }
}
