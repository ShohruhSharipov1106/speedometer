import 'package:flutter/material.dart';

class StopButton extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onStop;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final bool isPaused;
  const StopButton(
      {required this.onReset,
      required this.onStop,
      required this.onPause,
      required this.onResume,
      required this.isPaused,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            IconButton(
              padding: EdgeInsets.all(4),
              onPressed: onReset,
              icon: CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.rotate_right_outlined,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              "Qayta boshlash",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor: Colors.white24,
            fixedSize: Size(180, 52),
          ),
          onPressed: onStop,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.stop,
                color: Colors.cyanAccent,
                size: 30,
              ),
              Text(
                "Tugatish",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.cyanAccent,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Column(
            children: [
              IconButton(
                padding: EdgeInsets.all(4),
                onPressed: isPaused ? onResume : onPause,
                icon: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    isPaused ? Icons.play_arrow : Icons.pause,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                isPaused ? "Davom etish" : "To'xtatish",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
