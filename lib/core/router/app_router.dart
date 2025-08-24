// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/features/onboarding/onboarding_screen.dart';
import 'package:flutter_ui_kit_hotel/features/home/home_screen.dart';
import 'package:flutter_ui_kit_hotel/features/search/search_screen.dart';
import 'package:flutter_ui_kit_hotel/features/hotel_detail/hotel_detail_screen.dart';
import 'package:flutter_ui_kit_hotel/features/booking/booking_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    GoRoute(
      path: '/hotel/:id',
      builder: (ctx, st) => HotelDetailScreen(id: st.pathParameters['id']!),
    ),
    GoRoute(path: '/booking', builder: (_, __) => const BookingScreen()),
  ],
);
