import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/answer_enum.dart';
import '../models/question_model.dart';
import '../models/professor_model.dart';

class GameController extends ChangeNotifier {
  List<Question> _allQuestions = [];

  List<Professor> _allProfessors = [
    Professor(name: 'Fabiane Sorbar', traits: {}),
    Professor(name: 'Jefferson Speck', traits: {}),
    Professor(name: 'Jhoni Eldor', traits: {}),
    Professor(name: 'Willian Mendonça', traits: {}),
    Professor(name: 'Guilherme Alves', traits: {}),
    Professor(name: 'Marcos Guido', traits: {}),
    Professor(name: 'Letícia Siguinolfi', traits: {}),
    Professor(name: 'Jeferson Vorpagel', traits: {}),
    Professor(name: 'André Dorr', traits: {}),
    Professor(name: 'Renato Estevam', traits: {}),
    Professor(name: 'Marcel Augusto', traits: {}),
    Professor(name: 'Hiago Bruno', traits: {}),
    Professor(name: 'Daniele Wolfart', traits: {}),
    Professor(name: 'Alan Escher', traits: {}),
    Professor(name: 'Fabiano Dicheti', traits: {}),
  ];

  List<Professor> _activeProfessors = [];
  List<Question> _remainingQuestions = [];
  Question? _currentQuestion;
  Professor? _finalGuess;

  List<Question> get allQuestions => _allQuestions;
  List<Professor> get allProfessors => _allProfessors;
  Question? get currentQuestion => _currentQuestion;
  Professor? get finalGuess => _finalGuess;

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    final questionsJson = prefs.getString('saved_questions');
    if (questionsJson != null) {
      final List decoded = jsonDecode(questionsJson);
      _allQuestions = decoded.map((m) => Question.fromMap(m)).toList();
    }

    final professorsJson = prefs.getString('saved_professors');
    if (professorsJson != null) {
      final List decoded = jsonDecode(professorsJson);
      _allProfessors = decoded.map((m) => Professor.fromMap(m)).toList();
    }

    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    final questionsJson = jsonEncode(_allQuestions.map((q) => q.toMap()).toList());
    await prefs.setString('saved_questions', questionsJson);

    final professorsJson = jsonEncode(_allProfessors.map((p) => p.toMap()).toList());
    await prefs.setString('saved_professors', professorsJson);
  }

  void startGame() {
    _activeProfessors = _allProfessors.map((p) {
      p.reset();
      return p.copy();
    }).toList();
    _remainingQuestions = List.from(_allQuestions);
    _finalGuess = null;
    _selectBestNextQuestion();
    notifyListeners();
  }

  bool answerQuestion(AnswerOption answer) {
    if (_currentQuestion == null) return false;

    final qId = _currentQuestion!.id;

    switch (answer) {
      case AnswerOption.sim:
        _activeProfessors.removeWhere((p) => p.traits[qId] != true);
        break;
      case AnswerOption.nao:
        _activeProfessors.removeWhere((p) => p.traits[qId] != false);
        break;
      case AnswerOption.provavelmenteSim:
        for (var p in _activeProfessors) {
          if (p.traits[qId] == true) p.score += 1.5;
        }
        break;
      case AnswerOption.provavelmenteNao:
        for (var p in _activeProfessors) {
          if (p.traits[qId] == false) p.score += 1.5;
        }
        break;
      case AnswerOption.naoSei:
        // Does nothing
        break;
    }

    _remainingQuestions.removeWhere((q) => q.id == qId);

    if (_activeProfessors.isEmpty ||
        _activeProfessors.length == 1 ||
        _remainingQuestions.isEmpty) {
      if (_activeProfessors.isEmpty) {
        _finalGuess = null;
      } else {
        _activeProfessors.sort((a, b) => b.score.compareTo(a.score));
        _finalGuess = _activeProfessors.first;
      }
      return true;
    }

    _selectBestNextQuestion();
    notifyListeners();
    return false;
  }

  void _selectBestNextQuestion() {
    if (_remainingQuestions.isEmpty) {
      _currentQuestion = null;
      return;
    }

    Question? bestQ;
    int minDiff = _activeProfessors.length + 1;

    for (var q in _remainingQuestions) {
      int trueCount = 0;
      int falseCount = 0;

      for (var p in _activeProfessors) {
        if (p.traits[q.id] == true) trueCount++;
        if (p.traits[q.id] == false) falseCount++;
      }

      int diff = (trueCount - falseCount).abs();
      if (diff < minDiff) {
        minDiff = diff;
        bestQ = q;
      }
    }

    _currentQuestion = bestQ;
  }

  // Admin CRUD
  Future<void> addQuestion(String text, Map<String, bool?> professorAnswers) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newQ = Question(id: id, text: text);
    _allQuestions.add(newQ);

    for (var p in _allProfessors) {
      p.traits[id] = professorAnswers[p.name];
    }
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> updateQuestion(Question q, Map<String, bool?> professorAnswers) async {
    final index = _allQuestions.indexWhere((item) => item.id == q.id);
    if (index != -1) {
      _allQuestions[index] = q;
      for (var p in _allProfessors) {
        p.traits[q.id] = professorAnswers[p.name];
      }
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteQuestion(String id) async {
    _allQuestions.removeWhere((q) => q.id == id);
    for (var p in _allProfessors) {
      p.traits.remove(id);
    }
    await _saveToStorage();
    notifyListeners();
  }
}
