import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'question_screen.dart';
import 'admin_questions_screen.dart';
import '../widgets/custom_speech_bubble.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Como Jogar'),
          ],
        ),
        content: const Text(
          '1. Pense em um professor que já te deu aula.\n\n'
          '2. O Jeffnator fará perguntas sobre as características e a didática desse professor.\n\n'
          '3. Responda com sinceridade usando as opções fornecidas.\n\n'
          '4. Divirta-se!',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi!'),
          ),
        ],
      ),
    );
  }

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
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showInstructions(context),
          ),
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
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: CustomSpeechBubble(
                            text: "Pense em um professor de TI e eu vou tentar adivinhar!",
                            borderColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // Start Button
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 0),
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
                      'Jogar',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
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
