import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedGauge extends StatelessWidget {
  final int speed;
  const SpeedGauge({required this.speed, super.key});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 200,
          ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 60, color: Colors.green),
            GaugeRange(startValue: 60, endValue: 100, color: Colors.orange),
            GaugeRange(
                startValue: 100, endValue: 120, color: Colors.deepOrange),
            GaugeRange(startValue: 120, endValue: 200, color: Colors.red),
          ],
          canRotateLabels: true,
          showFirstLabel: true,
          showLabels: true,
          showLastLabel: true,
          axisLabelStyle: const GaugeTextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          labelsPosition: ElementsPosition.inside,
          pointers: <GaugePointer>[NeedlePointer(value: speed.toDouble())],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Container(
                child: Text(
                  speed.toString(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        )
      ],
    );
  }
}
