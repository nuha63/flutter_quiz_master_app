import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/quiz_category.dart';
import '../models/quiz_result.dart';
import '../services/storage_service.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  int _correctAnswers = 0;

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _onNextPressed() {
    if (_selectedOptionIndex == null) return;

    if (_selectedOptionIndex == widget.category.questions[_currentQuestionIndex].correctAnswerIndex) {
      _correctAnswers++;
    }

    if (_currentQuestionIndex < widget.category.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    final result = QuizResult(
      totalQuestions: widget.category.questions.length,
      correctAnswers: _correctAnswers,
      date: DateTime.now(),
    );
    await StorageService.saveResult(result);
    if (mounted) {
      context.pushReplacement('/result', extra: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.category.questions[_currentQuestionIndex];
    final totalQuestions = widget.category.questions.length;
    final progress = (_currentQuestionIndex + 1) / totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of $totalQuestions',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          currentQuestion.question,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(currentQuestion.options.length, (index) {
                      final option = currentQuestion.options[index];
                      final isSelected = _selectedOptionIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: OutlinedButton(
                          onPressed: () => _onOptionSelected(index),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            side: BorderSide(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              width: isSelected ? 2 : 1,
                            ),
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
                                : null,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${String.fromCharCode(65 + index)}.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedOptionIndex != null ? _onNextPressed : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentQuestionIndex == totalQuestions - 1 ? 'Finish' : 'Next',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
