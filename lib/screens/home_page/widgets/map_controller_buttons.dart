import 'package:flutter/material.dart';

class MapControllerButtons extends StatelessWidget {
  final VoidCallback onPlusTap;
  final VoidCallback onMinusTap;

  const MapControllerButtons({
    required this.onMinusTap,
    required this.onPlusTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: onPlusTap,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.add),
                ),
              ),
              Container(
                height: 1,
                width: 28,
                color: Colors.grey[300],
              ),
              InkWell(
                onTap: onMinusTap,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.remove),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedLocationIcon extends StatefulWidget {
  const AnimatedLocationIcon({super.key});

  @override
  State<AnimatedLocationIcon> createState() => _AnimatedLocationIconState();
}

class _AnimatedLocationIconState extends State<AnimatedLocationIcon>
    with TickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);
    _iconAnimation =
        Tween<double>(begin: 1, end: 2.3).animate(_iconAnimationController);
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: _iconAnimation,
          child: Container(
            height: 6,
            width: 6,
            decoration: const BoxDecoration(
                color: Colors.cyanAccent, shape: BoxShape.circle),
          ),
        ),
        const Icon(Icons.location_searching),
      ],
    );
  }
}
