import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/answer_enum.dart';
import 'result_screen.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  void _handleAnswer(BuildContext context, AnswerOption option) {
    final controller = context.read<GameController>();
    final gameEnded = controller.answerQuestion(option);
    if (gameEnded) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final currentQuestion = controller.currentQuestion;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adivinhando...'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: currentQuestion == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        currentQuestion.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ...AnswerOption.values.map((option) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                child: SizedBox(
                                  width:
                                      double.infinity, // Fills the 400px constraint
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .primaryColor, // University's Maroon color
                                      foregroundColor:
                                          Colors.white, // White text for contrast
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              14), // Slightly smaller height
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                    ),
                                    onPressed: () =>
                                        _handleAnswer(context, option),
                                    child: Text(
                                      option.label,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
