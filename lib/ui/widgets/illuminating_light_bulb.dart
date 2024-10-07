import 'dart:math';

import 'package:flutter/material.dart';

class IlluminatingLightbulb extends StatefulWidget {
  final Widget child;

  const IlluminatingLightbulb({super.key, required this.child});

  @override
  _IlluminatingLightbulbState createState() => _IlluminatingLightbulbState();
}

class _IlluminatingLightbulbState extends State<IlluminatingLightbulb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOn = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLight() {
    setState(() {
      _isOn = !_isOn;
      if (_isOn) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: LightPainter(_controller.value),
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _toggleLight,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      _isOn
                          ? "assets/lightbulb.png"
                          : "assets/lightbulb-off.png",
                      height: 180,
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class LightPainter extends CustomPainter {
  final double intensity;

  LightPainter(this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 100);
    final radius = min(size.width, size.height);

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.yellow.withOpacity(0.7 * intensity),
          Colors.yellow.withOpacity(0.3 * intensity),
          Colors.yellow.withOpacity(0.1 * intensity),
          Colors.yellow.withOpacity(0),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
