// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/atoms/app_button.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/atoms/resilient_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _slides = const [
    _Slide(
      title: 'Find your perfect stay',
      subtitle:
          'Search thousands of stays across cities and beaches worldwide.',
      // ảnh nền mock (picsum) — không cần asset
      image: 'https://picsum.photos/seed/hotel-1/1200/1800',
    ),
    _Slide(
      title: 'Compare with confidence',
      subtitle: 'See ratings, reviews and transparent prices at a glance.',
      image: 'https://picsum.photos/seed/hotel-2/1200/1800',
    ),
    _Slide(
      title: 'Book in seconds',
      subtitle: 'Secure checkout and instant confirmation. Easy.',
      image: 'https://picsum.photos/seed/hotel-3/1200/1800',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (page != _index) setState(() => _index = page);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() => context.go('/');

  void _next() {
    if (_index == _slides.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLast = _index == _slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // ===== Background slideshow (parallax light) =====
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              itemCount: _slides.length,
              itemBuilder: (context, i) {
                // Parallax nhẹ theo offset
                final page = (_controller.page ?? _index)
                    .clamp(0, _slides.length - 1)
                    .toDouble();
                final delta = (i - page);
                final translate = delta * 24; // px

                return Transform.translate(
                  offset: Offset(translate, 0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Ảnh nền
                      ResilientImage(
                        url: _slides[i].image,
                        fit: BoxFit.cover,
                        width: 1200,
                        height: 1800,
                      ),
                      // Overlay gradient: trên tối nhẹ để chữ nổi, dưới mờ để thấy ảnh
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: .55),
                              Colors.black.withValues(alpha: .15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ===== Top bar (Skip) =====
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Semantics(
                  button: true,
                  label: 'Skip onboarding',
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: .95),
                      backgroundColor: Colors.black.withValues(alpha: .15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999)),
                    ),
                    onPressed: _finish,
                    child: const Text('Skip'),
                  ),
                ),
              ),
            ),
          ),

          // ===== Main content (title/subtitle + dots + CTA) =====
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title + Subtitle animated
                    _AnimatedCopy(
                      key: ValueKey(_index),
                      title: _slides[_index].title,
                      subtitle: _slides[_index].subtitle,
                    ),
                    const Gap(20),

                    // Dots
                    _Dots(
                      length: _slides.length,
                      index: _index,
                      activeColor: cs.primary,
                      inactiveColor: Colors.white.withValues(alpha: .35),
                    ),
                    const Gap(16),

                    // CTA
                    AppButton(
                      label: isLast ? 'Get started' : 'Next',
                      onPressed: _next,
                      // style nhẹ: bán trong suốt để hợp ảnh nền
                    ),
                    const Gap(8),

                    // Tip nhỏ (optional)
                    Text(
                      'No ads. No hidden fees.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: .85),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  final String title;
  final String subtitle;
  final String image;
  const _Slide(
      {required this.title, required this.subtitle, required this.image});
}

class _AnimatedCopy extends StatelessWidget {
  const _AnimatedCopy({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      header: true,
      label: '$title. $subtitle',
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: Column(
          key: ValueKey(title),
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: .9),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.length,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int length;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Onboarding step ${index + 1} of $length',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (i) {
          final active = i == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: active ? 24 : 8,
            decoration: BoxDecoration(
              color: active ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(99),
            ),
          );
        }),
      ),
    );
  }
}
