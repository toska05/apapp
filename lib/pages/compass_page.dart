import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

class CompassPage extends StatelessWidget {
  const CompassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Compass(),
    );
  }
}
class Compass extends StatefulWidget {
  const Compass({super.key});

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  MagnetometerEvent _magnetometerEvent =
      MagnetometerEvent(0, 0, 0, DateTime.now());

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = magnetometerEventStream().listen((event) {
      setState(() {
        _magnetometerEvent = event;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  double _calculateDegrees(double x, double y) {
    double heading = math.atan2(y, x);
    heading = heading * (180 / math.pi);

    // Ensure the value is between 0 and 360
    if (heading < 0) {
      heading -= 360;
    }

    return heading * -1;
  }

  @override
  Widget build(BuildContext context) {
    final degrees =
        _calculateDegrees(_magnetometerEvent.x, _magnetometerEvent.y);
    final angle = degrees * (math.pi / 180);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring with cardinal directions
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Fill with white color
                  border: Border.all(color: Colors.black, width: 6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.5 * 255).toInt()),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: CompassRingPainter(angle), // Pass the angle here
                ),
              ),
              // Rotating arrow
              Transform.rotate(
                angle: 0,
                child: const Icon(
                  Icons.navigation,
                  size: 150,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('Degrees: ${degrees.toStringAsFixed(0)} °'),
        ],
      ),
    );
  }
}

class CompassRingPainter extends CustomPainter {
  final double angle;

  // Pass the angle from the _CompassState to rotate the directions correctly
  CompassRingPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Save the current state of the canvas before rotation
    canvas.save();

    // Translate to the center of the canvas and then rotate
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle); // Rotate the canvas by the current heading

    // Draw the cardinal direction text
    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // North
    textPainter.text = const  TextSpan(
      text: 'N',
      style: TextStyle(color: Colors.red, fontSize: 20),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-6, -radius + 10));

    // East
    textPainter.text = const TextSpan(
      text: 'E',
      style: TextStyle(color: Colors.black, fontSize: 20),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(radius - textPainter.width - 12 , -10));

    // South
    textPainter.text = const TextSpan(
      text: 'S',
      style: TextStyle(color: Colors.black, fontSize: 20),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-6, radius - textPainter.height - 10 ));

    // West
    textPainter.text = const TextSpan(
      text: 'W',
      style: TextStyle(color: Colors.black, fontSize: 20),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-radius + 12, -12));

    // Draw Lines for the compass ring going around the circle between the cardinal directions

    for (int i = 0; i < 360; i += 15) {
      double x1 = radius * math.cos(i * math.pi / 180);
      double y1 = radius * math.sin(i * math.pi / 180);
      double x2 = (radius - 10) * math.cos(i * math.pi / 180);
      double y2 = (radius - 10) * math.sin(i * math.pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Draw the circle for the compass ring
    canvas.drawCircle(const Offset(0, 0), radius, paint);

    // Restore the canvas to its original state (undo the translation and rotation)
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
