import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/answer_enum.dart';
import '../models/question_model.dart';
import '../models/professor_model.dart';

class GameController extends ChangeNotifier {
  List<Question> _allQuestions = [
    Question(id: 'q1', text: 'É mulher?'),
    Question(id: 'q2', text: 'Usa óculos de grau habitualmente?'),
    Question(id: 'q3', text: 'Usa apenas bigode (sem a barba completa)?'),
    Question(id: 'q4', text: 'Tem barba (mesmo que seja pequena ou por fazer)?'),
    Question(id: 'q5', text: 'É careca ou tem o cabelo rapado?'),
    Question(id: 'q6', text: 'Tem tatuagens bastante visíveis nos braços?'),
    Question(id: 'q7', text: 'É o(a) atual coordenador(a) do curso?'),
    Question(id: 'q8', text: 'Costuma dar aulas usando a camiseta da faculdade ou empresa?'),
    Question(id: 'q9', text: 'Ensina linguagens de programação (Backend, Mobile, Rust, etc.)?'),
    Question(id: 'q10', text: 'Ensina Banco de Dados?'),
    Question(id: 'q11', text: 'Ensina Infraestrutura, Redes ou Cibersegurança?'),
    Question(id: 'q12', text: 'Orienta a disciplina de Projeto Integrador (PI)?'),
    Question(id: 'q13', text: 'Ensina matérias de Gestão, Requisitos de Software ou Testes?'),
    Question(id: 'q14', text: 'Costuma falar termos em inglês ou dar exemplos no idioma?'),
    Question(id: 'q15', text: 'Faz alguma dinâmica para pedir silêncio (como bater palmas)?'),
    Question(id: 'q16', text: 'Costuma passar listas de exercícios estruturadas?'),
    Question(id: 'q17', text: 'Costuma passar atividades práticas curtas na aula?'),
    Question(id: 'q18', text: 'É rigoroso(a) ao cobrar organização e documentação?'),
    Question(id: 'q19', text: 'Costuma programar e discutir código ao vivo na sala?'),
    Question(id: 'q20', text: 'Dá a grande maioria das suas aulas no laboratório?'),
  ];

  List<Professor> _allProfessors = [
    Professor(name: 'Fabiane', traits: {'q1': true, 'q2': true, 'q3': false, 'q4': false, 'q5': false, 'q6': null, 'q7': true, 'q8': true, 'q9': true, 'q10': false, 'q11': false, 'q12': false, 'q13': false, 'q14': null, 'q15': false, 'q16': true, 'q17': true, 'q18': true, 'q19': false, 'q20': false}),
    Professor(name: 'Jefferson Speck', traits: {'q1': false, 'q2': true, 'q3': false, 'q4': true, 'q5': false, 'q6': true, 'q7': false, 'q8': false, 'q9': true, 'q10': false, 'q11': false, 'q12': false, 'q13': false, 'q14': null, 'q15': false, 'q16': false, 'q17': false, 'q18': null, 'q19': true, 'q20': false}),
    Professor(name: 'Jhoni', traits: {'q1': false, 'q2': false, 'q3': false, 'q4': true, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': true, 'q10': false, 'q11': false, 'q12': false, 'q13': false, 'q14': null, 'q15': false, 'q16': false, 'q17': true, 'q18': null, 'q19': true, 'q20': false}),
    Professor(name: 'Willian', traits: {'q1': false, 'q2': true, 'q3': false, 'q4': true, 'q5': false, 'q6': null, 'q7': false, 'q8': true, 'q9': false, 'q10': true, 'q11': false, 'q12': true, 'q13': false, 'q14': null, 'q15': false, 'q16': true, 'q17': null, 'q18': true, 'q19': null, 'q20': false}),
    Professor(name: 'Guilherme Alves', traits: {'q1': false, 'q2': true, 'q3': true, 'q4': false, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': true, 'q10': false, 'q11': false, 'q12': false, 'q13': false, 'q14': null, 'q15': false, 'q16': null, 'q17': null, 'q18': null, 'q19': true, 'q20': false}),
    Professor(name: 'Marcos Guido', traits: {'q1': false, 'q2': false, 'q3': false, 'q4': false, 'q5': true, 'q6': null, 'q7': false, 'q8': false, 'q9': false, 'q10': false, 'q11': true, 'q12': false, 'q13': false, 'q14': null, 'q15': false, 'q16': null, 'q17': true, 'q18': null, 'q19': false, 'q20': true}),
    Professor(name: 'Letícia', traits: {'q1': true, 'q2': true, 'q3': false, 'q4': false, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': false, 'q10': false, 'q11': true, 'q12': false, 'q13': false, 'q14': null, 'q15': false, 'q16': null, 'q17': true, 'q18': null, 'q19': false, 'q20': false}),
    Professor(name: 'Jeferson Vorpagel', traits: {'q1': false, 'q2': false, 'q3': false, 'q4': true, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': true, 'q10': false, 'q11': false, 'q12': false, 'q13': false, 'q14': null, 'q15': false, 'q16': null, 'q17': null, 'q18': true, 'q19': null, 'q20': false}),
    Professor(name: 'André Dorr', traits: {'q1': false, 'q2': true, 'q3': false, 'q4': true, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': false, 'q10': false, 'q11': false, 'q12': true, 'q13': true, 'q14': null, 'q15': false, 'q16': null, 'q17': null, 'q18': true, 'q19': false, 'q20': false}),
    Professor(name: 'Renato', traits: {'q1': false, 'q2': false, 'q3': false, 'q4': false, 'q5': false, 'q6': true, 'q7': false, 'q8': false, 'q9': true, 'q10': false, 'q11': false, 'q12': true, 'q13': false, 'q14': null, 'q15': false, 'q16': true, 'q17': null, 'q18': true, 'q19': true, 'q20': false}),
    Professor(name: 'Marcel', traits: {'q1': false, 'q2': true, 'q3': false, 'q4': true, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': false, 'q10': false, 'q11': false, 'q12': false, 'q13': false, 'q14': true, 'q15': false, 'q16': null, 'q17': null, 'q18': true, 'q19': false, 'q20': false}),
    Professor(name: 'Hiago', traits: {'q1': false, 'q2': false, 'q3': false, 'q4': true, 'q5': false, 'q6': null, 'q7': false, 'q8': true, 'q9': false, 'q10': false, 'q11': false, 'q12': false, 'q13': true, 'q14': null, 'q15': false, 'q16': null, 'q17': true, 'q18': true, 'q19': false, 'q20': false}),
    Professor(name: 'Dani', traits: {'q1': true, 'q2': false, 'q3': false, 'q4': false, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': false, 'q10': false, 'q11': false, 'q12': false, 'q13': true, 'q14': null, 'q15': false, 'q16': null, 'q17': true, 'q18': null, 'q19': false, 'q20': false}),
    Professor(name: 'Alan', traits: {'q1': false, 'q2': true, 'q3': false, 'q4': false, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': false, 'q10': false, 'q11': false, 'q12': true, 'q13': false, 'q14': null, 'q15': false, 'q16': null, 'q17': null, 'q18': true, 'q19': false, 'q20': false}),
    Professor(name: 'Fabiano', traits: {'q1': false, 'q2': true, 'q3': false, 'q4': true, 'q5': false, 'q6': null, 'q7': false, 'q8': false, 'q9': true, 'q10': false, 'q11': false, 'q12': false, 'q13': false, 'q14': null, 'q15': true, 'q16': null, 'q17': null, 'q18': null, 'q19': true, 'q20': false}),
  ];

  List<Professor> _activeProfessors = [];
  List<Question> _remainingQuestions = [];
  Question? _currentQuestion;
  Professor? _finalGuess;


  List<Question> get allQuestions => _allQuestions;
  List<Professor> get allProfessors => _allProfessors;
  Question? get currentQuestion => _currentQuestion;
  Professor? get finalGuess => _finalGuess;
  final Map<String, AnswerOption> _answers = {};  

  bool _isYes(String questionId) {
  return _answers[questionId] == AnswerOption.sim ||
      _answers[questionId] == AnswerOption.provavelmenteSim;
}

bool _isNo(String questionId) {
  return _answers[questionId] == AnswerOption.nao ||
      _answers[questionId] == AnswerOption.provavelmenteNao;
}

void _checkSpecialRules() {
  // FABIANE
  if (_isYes('q1') && _isYes('q7')) {
    _finalGuess =
        _allProfessors.firstWhere((p) => p.name == 'Fabiane');
    return;
  }

  // LETÍCIA
  if (_isYes('q1') && _isYes('q11')) {
    _finalGuess =
        _allProfessors.firstWhere((p) => p.name == 'Letícia');
    return;
  }

  // DANI
  if (_isYes('q1') && _isYes('q13')) {
    _finalGuess =
        _allProfessors.firstWhere((p) => p.name == 'Dani');
    return;
  }

  // MARCOS GUIDO
  if (_isNo('q1') &&
      _isYes('q5') &&
      _isYes('q11')) {
    _finalGuess =
        _allProfessors.firstWhere((p) => p.name == 'Marcos Guido');
    return;
  }

  // WILLIAN
  if (_isNo('q1') && _isYes('q10')) {
    _finalGuess =
        _allProfessors.firstWhere((p) => p.name == 'Willian');
    return;
  }

  // GUILHERME
  if (_isNo('q1') && _isYes('q3')) {
    _finalGuess =
        _allProfessors.firstWhere((p) => p.name == 'Guilherme Alves');
    return;
  }

  // FABIANO
  if (_isNo('q1') && _isYes('q15')) {
    _finalGuess =
        _allProfessors.firstWhere((p) => p.name == 'Fabiano');
    return;
  }

  // MARCEL
  if (_isNo('q1') && _isYes('q14')) {
    _finalGuess =
        _allProfessors.firstWhere((p) => p.name == 'Marcel');
    return;
  }
}

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
  _answers.clear();

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
    
    _answers[qId] = answer;

    _checkSpecialRules();

    if (_finalGuess != null) {
      notifyListeners();
      return true;
    }

    if (qId == 'q1') {
      if (answer == AnswerOption.sim || answer == AnswerOption.provavelmenteSim) {
        _remainingQuestions.removeWhere((q) => q.id == 'q3' || q.id == 'q4' || q.id == 'q5');
      }
    }

    for (var p in _activeProfessors) {
      bool? dbTrait = p.traits[qId];
      if (dbTrait == null) continue;

      // Atalhos de Decisão Inteligente
      if (answer == AnswerOption.sim) {
        if (qId == 'q11' && p.name == 'Marcos Guido') p.score += 15.0; // Homem + Infra
        if (qId == 'q10' && p.name == 'Willian') p.score += 15.0;      // Homem + DB
        if (qId == 'q13' && p.name == 'Dani') p.score += 15.0;         // Mulher + Gestão
        if (qId == 'q7' && p.name == 'Fabiane') p.score += 15.0;       // Mulher + Coord
        if (qId == 'q11' && p.name == 'Letícia') p.score += 15.0;      // Mulher + Cyber
      }
      
      // André: Homem (q1=nao) + Barba (q4=sim) + Testes (q13=sim)
      if (p.name == 'André Dorr' && qId == 'q13' && answer == AnswerOption.sim) p.score += 8.0;

      switch (answer) {
        case AnswerOption.sim:
          dbTrait == true ? p.score += 2.0 : p.score -= 2.0;
          break;
        case AnswerOption.nao:
          dbTrait == false ? p.score += 2.0 : p.score -= 2.0;
          break;
        case AnswerOption.provavelmenteSim:
          dbTrait == true ? p.score += 1.0 : p.score -= 1.0;
          break;
        case AnswerOption.provavelmenteNao:
          dbTrait == false ? p.score += 1.0 : p.score -= 1.0;
          break;
        case AnswerOption.naoSei: break;
      }
    }

    _remainingQuestions.removeWhere((q) => q.id == qId);
    _activeProfessors.removeWhere((p) => p.score <= -4.0);

    if (_activeProfessors.length <= 1 || _remainingQuestions.isEmpty) {
      if (_activeProfessors.isNotEmpty) {
        _activeProfessors.sort((a, b) => b.score.compareTo(a.score));
        _finalGuess = _activeProfessors.first;
      } else {
        _finalGuess = null; 
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
    _currentQuestion = _remainingQuestions.first;
  }

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