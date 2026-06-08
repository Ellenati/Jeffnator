import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'question_form_screen.dart';

class AdminQuestionsScreen extends StatelessWidget {
  const AdminQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final questions = controller.allQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Perguntas'),
      ),
      body: questions.isEmpty
          ? const Center(child: Text('Nenhuma pergunta cadastrada.'))
          : ListView.builder(
              itemCount: questions.size,
              itemBuilder: (context, index) {
                final q = questions[index];
                return ListTile(
                  title: Text(q.text),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      controller.deleteQuestion(q.id);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionFormScreen(question: q),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension on List {
  int get size => length;
}
