// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../screens/quiz_screen.dart';
import '../constants/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Use mainAxisAlignment to distribute remaining space
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // Top padding
              // Image Container - USE Expanded to prevent overflow
              Expanded(
                // <-- CHANGE 1: Use Expanded instead of a fixed height
                child: Container(
                  width: double.infinity,
                  // height: 400, // <-- REMOVE fixed height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/splash.png', // Change this to your image path
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if image not found (similar to the image you shared)
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0C4A6E), Color(0xFF082F49)],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 64,
                              color: Colors.white24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // const Spacer(), // <-- REMOVE one Spacer
              const SizedBox(height: 32), // Space between image and title
              // Title
              const Text(
                'Tech Trivia',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Test your knowledge of the tech world',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 40), // Space above button
              // Start Quiz Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
