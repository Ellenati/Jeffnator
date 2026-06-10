import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'question_screen.dart';
import 'admin_questions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
          alignment: Alignment.centerLeft,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminQuestionsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Jeffnator',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.5,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              // 1. UPDATED INVERTED OVERLAPPING AREA
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // 1. BOTTOM LAYER (Z-axis): The Character (Rendered first, stays behind, positioned at the TOP)
                    Positioned(
                      top: -10, // Anchored to the top
                      child: Image.asset(
                        'assets/images/jeffnator.png',
                        height:
                            480, // Sized so the bottom of the image reaches the bubble
                        fit: BoxFit.contain,
                      ),
                    ),

                    // 2. TOP LAYER (Z-axis): The Speech Bubble
                    Positioned(
                      bottom: 30,
                      left: 24,
                      right: 24,
                      child: CustomPaint(
                        painter: SpeechBubblePainter(),
                        child: const Padding(
                          // Extra top padding ensures the text doesn't hit the drawn tail
                          padding: EdgeInsets.only(
                            top: 40.0,
                            bottom: 24.0,
                            left: 24.0,
                            right: 24.0,
                          ),
                          child: Text(
                            "Pense em um professor e eu vou tentar adivinhar!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // Start Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.read<GameController>().startGame();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestionScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Começar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.92)
      ..style = PaintingStyle.fill;

    final path = Path();
    const tailWidth = 24.0;
    const tailHeight = 16.0;
    const radius = 20.0;

    // Start drawing from top-left, just below the tail height
    path.moveTo(radius, tailHeight);

    // Draw the tail pointing UP in the center
    path.lineTo(size.width / 2 - tailWidth / 2, tailHeight);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width / 2 + tailWidth / 2, tailHeight);

    // Top-right corner
    path.lineTo(size.width - radius, tailHeight);
    path.quadraticBezierTo(
      size.width,
      tailHeight,
      size.width,
      tailHeight + radius,
    );

    // Bottom-right corner
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );

    // Bottom-left corner
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // Top-left corner
    path.lineTo(0, tailHeight + radius);
    path.quadraticBezierTo(0, tailHeight, radius, tailHeight);

    path.close();

    // Draw shadow (transparentOccluder: false prevents the shadow from rendering underneath the transparent bubble)
    canvas.drawShadow(path, Colors.black, 10.0, false);

    // Fill the shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
