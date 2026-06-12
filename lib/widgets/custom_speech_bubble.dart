import 'package:flutter/material.dart';

class CustomSpeechBubble extends StatelessWidget {
  final String text;
  final Color borderColor;

  const CustomSpeechBubble({super.key, required this.text, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpeechBubblePainter(
        fillColor: Colors.white.withOpacity(0.92),
        borderColor: borderColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, bottom: 24.0, left: 24.0, right: 24.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;

  _SpeechBubblePainter({required this.fillColor, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = borderColor
      ..strokeWidth = 2.5 // The thickness of the border
      ..style = PaintingStyle.stroke;

    final path = Path();
    const tailWidth = 24.0;
    const tailHeight = 16.0;
    const radius = 20.0;

    path.moveTo(radius, tailHeight);
    path.lineTo(size.width / 2 - tailWidth / 2, tailHeight);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width / 2 + tailWidth / 2, tailHeight);
    path.lineTo(size.width - radius, tailHeight);
    path.quadraticBezierTo(size.width, tailHeight, size.width, tailHeight + radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, tailHeight + radius);
    path.quadraticBezierTo(0, tailHeight, radius, tailHeight);
    path.close();

    canvas.drawShadow(path, Colors.black, 10.0, false);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint); // Draws the border
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
