import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'home_screen.dart';
import 'question_screen.dart';
import '../widgets/custom_speech_bubble.dart';

enum ResultViewState { asking, success, failure }

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ResultViewState _viewState = ResultViewState.asking;

  void _restartGame() {
    Provider.of<GameController>(context, listen: false).startGame();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _handleNo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quase lá!', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Deseja continuar jogando para ver se eu ainda consigo adivinhar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() => _viewState = ResultViewState.failure);
            },
            child: const Text('Parar e Desistir', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              final controller = Provider.of<GameController>(context, listen: false);
              final canContinue = controller.continueGame();
              
              if (canContinue) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const QuestionScreen()),
                );
              } else {
                setState(() => _viewState = ResultViewState.failure);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Esgotei minhas opções! Você me venceu.')),
                );
              }
            },
            child: const Text('Continuar Jogando'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameController>(context);

    return Scaffold(
      // The AppBar has been completely removed
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: _buildBody(controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(GameController controller) {
    if (_viewState == ResultViewState.asking) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'O professor que você pensou é:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 24),
          Text(
            controller.finalGuess?.name ?? "Ninguém!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Eu acertei?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  elevation: 4,
                ),
                onPressed: () => setState(() => _viewState = ResultViewState.success),
                icon: const Icon(Icons.check),
                label: const Text('Sim!', style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  elevation: 4,
                ),
                onPressed: _handleNo,
                icon: const Icon(Icons.close),
                label: const Text('Não', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ],
      );
    }

    // Success or Failure View (Jeffnator talking)
    final isSuccess = _viewState == ResultViewState.success;
    final message = isSuccess 
        ? "Eu sou o mestre! Adivinhei mais uma vez!" 
        : "Você me venceu dessa vez... parabéns pela ótima escolha!";

    return Column(
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 1. BOTTOM LAYER: Giant Character Image anchored to the top
              Positioned(
                top: 0,
                child: Image.asset(
                  'assets/images/jeffnator.png',
                  height: 420, // Much larger now
                  fit: BoxFit.contain,
                ),
              ),
              
              // 2. TOP LAYER: The new bordered Speech Bubble overlapping the image
              Positioned(
                bottom: 20, // Anchored near the bottom to overlap the character's body
                left: 0,
                right: 0,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: CustomSpeechBubble(
                      text: message,
                      borderColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Play Again Button at the bottom
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            onPressed: _restartGame,
            icon: const Icon(Icons.refresh),
            label: const Text('Jogar Novamente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
