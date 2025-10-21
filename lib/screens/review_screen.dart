// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/question.dart';
import '../constants/app_colors.dart';
class AnswerReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<int, int?> userAnswers;

  const AnswerReviewScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Answer Review',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final userAnswer = userAnswers[index];
          final isCorrect = userAnswer == question.correctAnswer;
          final isUnanswered = userAnswer == null;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isUnanswered
                                ? AppColors.textSecondary.withOpacity(0.2)
                                : isCorrect
                                ? AppColors.success.withOpacity(0.2)
                                : AppColors.error.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isUnanswered
                                ? Icons.help_outline
                                : isCorrect
                                ? Icons.check_circle
                                : Icons.cancel,
                            color:
                                isUnanswered
                                    ? AppColors.textSecondary
                                    : isCorrect
                                    ? AppColors.success
                                    : AppColors.error,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isUnanswered
                                ? 'Unanswered'
                                : isCorrect
                                ? question.category
                                : 'Incorrect',
                            style: TextStyle(
                              color:
                                  isUnanswered
                                      ? AppColors.textSecondary
                                      : isCorrect
                                      ? AppColors.success
                                      : AppColors.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Question ${index + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(question.options.length, (optIndex) {
                  final isUserAnswer = userAnswer == optIndex;
                  final isCorrectAnswer = question.correctAnswer == optIndex;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          isCorrectAnswer
                              ? AppColors.success.withOpacity(0.15)
                              : isUserAnswer
                              ? AppColors.error.withOpacity(0.15)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            isCorrectAnswer
                                ? AppColors.success
                                : isUserAnswer
                                ? AppColors.error
                                : AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCorrectAnswer
                              ? Icons.check_circle
                              : isUserAnswer
                              ? Icons.cancel
                              : Icons.radio_button_unchecked,
                          color:
                              isCorrectAnswer
                                  ? AppColors.success
                                  : isUserAnswer
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question.options[optIndex],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
