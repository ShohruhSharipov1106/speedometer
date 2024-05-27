import 'package:flutter/material.dart';
import 'package:speedometer/config/storage.dart';

class SpeedWarning extends StatefulWidget {
  const SpeedWarning({super.key});

  @override
  State<SpeedWarning> createState() => _SpeedWarningState();
}

class _SpeedWarningState extends State<SpeedWarning> {
  late bool warning;
  late bool sound;
  late bool vibration;
  late String speed;

  @override
  void initState() {
    super.initState();
    warning = StorageRepository.getBool(StoreKeys.warning, defValue: true);
    sound = StorageRepository.getBool(StoreKeys.sound, defValue: true);
    vibration = StorageRepository.getBool(StoreKeys.vibration, defValue: true);
    speed = StorageRepository.getString(StoreKeys.speed, defValue: "100");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          SwitchListTile.adaptive(
            title: const Text(
              "Ogohlantirish",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.cyanAccent,
              ),
            ),
            value: warning,
            onChanged: (value) {
              setState(() {
                warning = value;
              });
              StorageRepository.putBool(key: StoreKeys.warning, value: warning);
            },
          ),
          DropdownButton(
            isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            borderRadius: BorderRadius.circular(8),
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            iconSize: 36,
            dropdownColor: Colors.grey[900],
            underline: Container(),
            items: [
              DropdownMenuItem(
                child: Text("60"),
                value: "60",
              ),
              DropdownMenuItem(
                child: Text("90"),
                value: "90",
              ),
              DropdownMenuItem(
                child: Text("100"),
                value: "100",
              ),
              DropdownMenuItem(
                child: Text("120"),
                value: "120",
              ),
            ],
            value: speed,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.cyanAccent,
            ),
            onChanged: (value) {
              setState(() {
                speed = value!;
              });
              StorageRepository.putString(StoreKeys.speed, speed);
            },
          ),
          SwitchListTile(
            title: const Text(
              "Ovoz",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            value: sound,
            onChanged: (value) {
              setState(() {
                sound = value;
              });
              StorageRepository.putBool(key: StoreKeys.sound, value: sound);
            },
          ),
          SwitchListTile(
            title: const Text(
              "Tebranish",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            value: vibration,
            onChanged: (value) {
              setState(() {
                vibration = value;
              });
              StorageRepository.putBool(
                  key: StoreKeys.vibration, value: vibration);
            },
          ),
        ],
      ),
    );
  }
}
