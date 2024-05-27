import 'package:flutter/material.dart';
import 'package:speedometer/screens/settings_page/widgets/speed_scale_control.dart';
import 'package:speedometer/screens/settings_page/widgets/speed_warning.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Sozlamalar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: const [
          SizedBox(height: 16),
          SpeedScaleControl(),
          SizedBox(height: 16),
          SpeedWarning(),
        ],
      ),
    );
  }
}
