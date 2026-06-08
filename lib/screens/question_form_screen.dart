import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/question_model.dart';

class QuestionFormScreen extends StatefulWidget {
  final Question? question;

  const QuestionFormScreen({super.key, this.question});

  @override
  State<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  late TextEditingController _textController;
  final Map<String, bool?> _professorAnswers = {};

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.question?.text ?? '');
    
    final controller = context.read<GameController>();
    for (var p in controller.allProfessors) {
      if (widget.question != null) {
        _professorAnswers[p.name] = p.traits[widget.question!.id];
      } else {
        _professorAnswers[p.name] = null;
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _save() {
    final text = _textController.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite a pergunta.')),
      );
      return;
    }

    final controller = context.read<GameController>();
    if (widget.question != null) {
      controller.updateQuestion(
        widget.question!.copyWith(text: text),
        _professorAnswers,
      );
    } else {
      controller.addQuestion(text, _professorAnswers);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question == null ? 'Nova Pergunta' : 'Editar Pergunta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Texto da Pergunta',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Mapeamento de Professores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: controller.allProfessors.length,
                itemBuilder: (context, index) {
                  final professor = controller.allProfessors[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            professor.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<bool?>(
                            segments: const [
                              ButtonSegment(value: true, label: Text('Sim')),
                              ButtonSegment(value: null, label: Text('Neutro')),
                              ButtonSegment(value: false, label: Text('Não')),
                            ],
                            selected: {_professorAnswers[professor.name]},
                            onSelectionChanged: (newSelection) {
                              setState(() {
                                _professorAnswers[professor.name] = newSelection.first;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
