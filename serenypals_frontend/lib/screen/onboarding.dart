import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../utils/color.dart';
import '../widget/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "text":
          "Beri dirimu waktu untuk tumbuh, dan bersabarlah dengan prosesnya",
      "image": "assets/img/onboarding1.png",
    },
    {
      "text":
          "Syukuri hal-hal kecil dalam hidup. Kebahagiaan datang dari hal-hal sederhana",
      "image": "assets/img/onboarding2.png",
    },
    {
      "text":
          "Jangan takut untuk meminta bantuan saat kamu membutuhkannya. Kamu tidak sendirian.",
      "image": "assets/img/onboarding3.png",
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  final isLast = index == _pages.length - 1;

                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(page['image'], height: 250),
                        const SizedBox(height: 32),
                        Text(
                          page['text'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.overlock(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[800],
                          ),
                        ),
                        if (isLast) ...[
                          const SizedBox(height: 48),
                          CustomButton(
                            text: 'Serenypals',
                            onPressed: () => context.go('/login'),
                            backgroundColor: color2,
                            textColor: Colors.black,
                            borderRadius: 24,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_currentPage != _pages.length - 1) ...[
              _buildIndicator(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.overlock(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    CustomButton(
                      text: 'Next',
                      onPressed: _nextPage,
                      backgroundColor: color2,
                      textColor: Colors.black,

                      borderRadius: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 15,
                      ),
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
