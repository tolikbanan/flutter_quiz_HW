import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/quiz_repository.dart';
import 'ui/home_screen.dart';
import 'viewmodels/quiz_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => QuizRepository()),
        ChangeNotifierProxyProvider<QuizRepository, QuizViewModel>(
          create: (context) => QuizViewModel(context.read<QuizRepository>()),
          update: (context, repository, viewModel) =>
              viewModel ?? QuizViewModel(repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
