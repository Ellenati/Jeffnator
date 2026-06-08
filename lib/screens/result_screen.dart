import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final guess = controller.finalGuess;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'O professor que você pensou é...',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                guess?.name ?? 'Não consegui adivinhar! :(',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 40),
              if (guess != null) ...[
                const Text('Acertei?'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Uhuu! Eu sabia!')),
                        );
                      },
                      child: const Text('Sim'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Poxa, vou estudar mais! Obrigado por jogar.')),
                        );
                      },
                      child: const Text('Não'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 60),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Jogar Novamente'),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
