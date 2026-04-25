import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuizRepository {
  Future<List<Question>> fetchQuestions() async {
    try {
      // Загрузка JSON файла из assets
      final String response = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> data = json.decode(response);
      
      return data.map((item) => Question.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      // В случае ошибки (файл не найден или неверный формат) выбрасываем исключение
      throw Exception('Ошибка загрузки вопросов: $e');
    }
  }
}
