import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final VoidCallback onStart;
  const StartButton({required this.onStart, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: Colors.cyanAccent,
        fixedSize: Size(180, 48),
      ),
      onPressed: onStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_right_sharp,
            color: Colors.black,
            size: 30,
          ),
          Text(
            "Boshlash",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
