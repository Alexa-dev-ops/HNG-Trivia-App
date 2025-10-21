// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'dart:async';
import '../data/questions.dart';
import '../constants/app_colors.dart';
import 'score_screen.dart';
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  int score = 0;
  Map<int, int?> userAnswers = {};

  // Timer variables
  Timer? _questionTimer;
  int _timeRemaining = 30;
  final int _totalTime = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeRemaining = _totalTime;
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _autoMoveToNext();
        }
      });
    });
  }

  void _autoMoveToNext() {
    _questionTimer?.cancel();

    if (selectedAnswer == null) {
      userAnswers[currentQuestionIndex] = null;
    } else {
      userAnswers[currentQuestionIndex] = selectedAnswer;
      if (selectedAnswer ==
          techTriviaQuestions[currentQuestionIndex].correctAnswer) {
        score++;
      }
    }

    if (currentQuestionIndex < techTriviaQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = userAnswers[currentQuestionIndex];
      });
      _startTimer();
    } else {
      _finishQuiz();
    }
  }

  void selectAnswer(int index) {
    setState(() {
      selectedAnswer = index;
    });
  }

  void nextQuestion() {
    _questionTimer?.cancel();

    setState(() {
      userAnswers[currentQuestionIndex] = selectedAnswer;
      if (selectedAnswer != null &&
          selectedAnswer ==
              techTriviaQuestions[currentQuestionIndex].correctAnswer) {
        score++;
      }

      if (currentQuestionIndex < techTriviaQuestions.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = userAnswers[currentQuestionIndex];
        _startTimer();
      } else {
        _finishQuiz();
      }
    });
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      _questionTimer?.cancel();
      setState(() {
        currentQuestionIndex--;
        selectedAnswer = userAnswers[currentQuestionIndex];
        _startTimer();
      });
    }
  }

  void _finishQuiz() {
    _questionTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => ScoreScreen(
              score: score,
              totalQuestions: techTriviaQuestions.length,
              questions: techTriviaQuestions,
              userAnswers: userAnswers,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = techTriviaQuestions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _questionTimer?.cancel();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tech Trivia',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Category and Timer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'QUESTION ${currentQuestionIndex + 1} OF ${techTriviaQuestions.length}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _timeRemaining <= 10
                            ? AppColors.error.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _timeRemaining <= 10
                              ? AppColors.error
                              : AppColors.primary,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color:
                            _timeRemaining <= 10
                                ? AppColors.error
                                : AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_timeRemaining}s',
                        style: TextStyle(
                          color:
                              _timeRemaining <= 10
                                  ? AppColors.error
                                  : AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Options with star icon for selected
                  ...List.generate(
                    question.options.length,
                    (index) => QuizOption(
                      option: question.options[index],
                      isSelected: selectedAnswer == index,
                      onTap: () => selectAnswer(index),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: previousQuestion,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Previous'),
                      ),
                    ),
                  ),
                if (currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        currentQuestionIndex < techTriviaQuestions.length - 1
                            ? 'Next'
                            : 'Finish',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Quiz Option Widget with star icon
class QuizOption extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizOption({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Star icon when selected, checkbox when not
              Icon(
                isSelected ? Icons.star : Icons.check_box_outline_blank,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
