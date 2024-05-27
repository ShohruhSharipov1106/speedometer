import 'package:flutter/material.dart';
import 'package:lcd_led/lcd_led.dart';
import 'package:speedometer/config/storage.dart';

class SpeedDigital extends StatelessWidget {
  final String speed;
  const SpeedDigital({required this.speed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 200,
            child: LedDigits(
              string: speed,
              numberOfLeds: 3,
              spacing: 5,
              backgroundColor: Colors.transparent, // default value
              onColor: Colors.cyanAccent, // default value
              offColor: Colors.transparent, // default value
            ),
          ),
          Text(
            "${StorageRepository.getString(StoreKeys.scale, defValue: "km/h")}",
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
