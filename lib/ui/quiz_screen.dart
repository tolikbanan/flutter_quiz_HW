import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quiz_viewmodel.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вопросы'),
        centerTitle: true,
      ),
      body: Consumer<QuizViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.state == QuizState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.state == QuizState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => viewModel.loadQuestions(),
                    child: const Text('Попробовать снова'),
                  )
                ],
              ),
            );
          }

          if (viewModel.state != QuizState.loaded) {
            return const SizedBox();
          }

          final question = viewModel.currentQuestion;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Прогресс
                Text(
                  'Вопрос ${viewModel.currentIndex + 1} из ${viewModel.totalQuestions}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (viewModel.currentIndex + 1) / viewModel.totalQuestions,
                ),
                const SizedBox(height: 32),

                // Вопрос
                Text(
                  question.text,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),

                // Варианты ответов
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      final isSelected = viewModel.selectedOptionIndex == index;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: InkWell(
                          onTap: () => viewModel.selectOption(index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey.shade300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Radio<int>(
                                  value: index,
                                  groupValue: viewModel.selectedOptionIndex,
                                  onChanged: (value) {
                                    if (value != null) {
                                      viewModel.selectOption(value);
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    question.options[index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Кнопка Далее
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: viewModel.hasSelectedOption
                        ? () {
                            viewModel.nextQuestion();
                            if (viewModel.state == QuizState.finished) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ResultScreen(),
                                ),
                              );
                            }
                          }
                        : null,
                    child: const Text('Далее', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
