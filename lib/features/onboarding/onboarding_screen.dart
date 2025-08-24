// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/core/widgets/atoms/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Find your perfect stay',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              Text(
                'Discover hotels, compare prices, and book with ease.',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(label: 'Get started', onPressed: () => context.go('/')),
            ],
          ),
        ),
      ),
    );
  }
}
