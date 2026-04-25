import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quiz_viewmodel.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<QuizViewModel>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Убираем кнопку назад
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Тест завершен!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              // Круговой индикатор или большой текст для счета
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                  border: Border.all(color: Colors.blueAccent, width: 4),
                ),
                child: Column(
                  children: [
                    Text(
                      '${viewModel.score} / ${viewModel.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Text(
                      '${viewModel.scorePercentage.toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                viewModel.scoreEvaluation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getEvaluationColor(viewModel.scorePercentage),
                ),
              ),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.resetQuiz();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    );
                  },
                  child: const Text('Пройти ещё раз', style: TextStyle(fontSize: 18)),
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    viewModel.resetQuiz();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('На главную', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getEvaluationColor(double percentage) {
    if (percentage < 50) return Colors.red;
    if (percentage <= 80) return Colors.orange;
    return Colors.green;
  }
}
