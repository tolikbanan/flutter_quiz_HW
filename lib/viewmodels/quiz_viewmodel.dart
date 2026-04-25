import 'package:flutter/material.dart';
import '../data/quiz_repository.dart';
import '../models/question.dart';

enum QuizState { initial, loading, loaded, error, finished }

class QuizViewModel extends ChangeNotifier {
  final QuizRepository _repository;

  QuizViewModel(this._repository);

  QuizState _state = QuizState.initial;
  QuizState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Question> _questions = [];
  List<Question> get questions => _questions;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  int _score = 0;
  int get score => _score;

  int? _selectedOptionIndex;
  int? get selectedOptionIndex => _selectedOptionIndex;

  Question get currentQuestion => _questions[_currentIndex];
  int get totalQuestions => _questions.length;
  bool get hasSelectedOption => _selectedOptionIndex != null;

  double get scorePercentage => totalQuestions == 0 ? 0 : (_score / totalQuestions) * 100;

  String get scoreEvaluation {
    if (scorePercentage < 50) return 'Нужно подтянуть';
    if (scorePercentage <= 80) return 'Хорошо';
    return 'Отлично';
  }

  Future<void> loadQuestions() async {
    _state = QuizState.loading;
    notifyListeners();

    try {
      _questions = await _repository.fetchQuestions();
      _state = QuizState.loaded;
      _currentIndex = 0;
      _score = 0;
      _selectedOptionIndex = null;
    } catch (e) {
      _state = QuizState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void selectOption(int index) {
    if (_state != QuizState.loaded) return;
    _selectedOptionIndex = index;
    notifyListeners();
  }

  void nextQuestion() {
    if (_state != QuizState.loaded || _selectedOptionIndex == null) return;

    if (_selectedOptionIndex == currentQuestion.correctAnswerIndex) {
      _score++;
    }

    if (_currentIndex < totalQuestions - 1) {
      _currentIndex++;
      _selectedOptionIndex = null;
    } else {
      _state = QuizState.finished;
    }
    notifyListeners();
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _selectedOptionIndex = null;
    _state = QuizState.loaded; // Сразу ставим loaded, так как вопросы уже в памяти
    notifyListeners();
  }
}
