import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ecommerecstore/constants/app_assets.dart';
import 'package:ecommerecstore/routes/app_routes.dart';

class _OnboardingPage {
  final String illustration;
  final String title;
  final String subtitle;
  final String buttonText;

  const _OnboardingPage({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}

const _pages = [
  _OnboardingPage(
    illustration: AppAssets.onboardingIllustration1,
    title: 'Get Fashion\nWithout Boundaries',
    subtitle:
        'From fresh and trendy arrivals to big summer deals, in one place.',
    buttonText: 'Get Started',
  ),
  _OnboardingPage(
    illustration: AppAssets.onboardingIllustration2,
    title: 'Fast & Reliable\nDelivery',
    subtitle:
        'Get your orders delivered to your doorstep quickly and safely with real-time tracking.',
    buttonText: 'Explore now',
  ),
  _OnboardingPage(
    illustration: AppAssets.onboardingIllustration3,
    title: 'Secure Payments\nMade Easy',
    subtitle:
        'Pay with your preferred method — cards, e-wallets or cash — all protected and safe.',
    buttonText: 'Start shopping',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: _goToLogin,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, i) =>
                    _OnboardingPageView(page: _pages[i]),
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? const Color(0xFFFF5722)
                        : const Color(0xFFD0D5DD),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Custom Onboarding Button exact match to Figma screenshot
            Center(
              child: SizedBox(
                width: 230,
                child: _PillArrowButton(
                  text: _pages[_currentPage].buttonText,
                  onTap: _next,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            page.illustration,
            height: 240,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF101828),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF667085),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Pill Button matching original Figma design (white circle with arrow on left, title, double chevron on right)
class _PillArrowButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PillArrowButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const kCoral = Color(0xFFFF6542);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: kCoral,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: kCoral.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left white circle with arrow matching screenshot
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: kCoral,
                size: 18,
              ),
            ),
            // Center text
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Right double chevron matching provided image (grey then white)
            SizedBox(
              width: 32,
              child: Stack(
                children: [
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 24,
                  ),
                  const Positioned(
                    left: 8,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
