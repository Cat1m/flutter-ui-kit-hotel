// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter_ui_kit_hotel/features/onboarding/onboarding_screen.dart';
import 'package:flutter_ui_kit_hotel/features/home/home_screen.dart';
import 'package:flutter_ui_kit_hotel/features/search/search_screen.dart';
import 'package:flutter_ui_kit_hotel/features/hotel/hotel_detail_screen.dart';
import 'package:flutter_ui_kit_hotel/features/booking/booking_screen.dart';

// ✳️ mới:
import 'package:flutter_ui_kit_hotel/features/listing/hotel_list_screen.dart';

final appRouter = GoRouter(
  // Bật log nếu muốn debug route:
  debugLogDiagnostics: true,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (_, __) => const SearchScreen(),
    ),

    // 🔹 Danh sách "See all" dùng chung cho Featured/Popular + Category
    //   Ví dụ điều hướng:
    //   context.push('/list?section=featured&category=Beach');
    //   context.push('/list?section=popular&category=All');
    GoRoute(
      path: '/list',
      builder: (context, state) {
        final section = state.uri.queryParameters['section'] ??
            'featured'; // 'featured' | 'popular'
        final category = state.uri.queryParameters['category'] ?? 'All';
        return HotelListScreen(section: section, category: category);
      },
    ),

    // 🔹 Chi tiết khách sạn
    //   Vẫn yêu cầu :id như cũ để tương thích HotelDetailScreen(id: ...)
    //   Đồng thời hỗ trợ query 'title' & 'image' (nếu bạn mở rộng màn chi tiết để nhận & dùng Hero).
    //   Ví dụ điều hướng:
    //   context.push('/hotel/$id?title=${Uri.encodeComponent(title)}&image=${Uri.encodeComponent(imageUrl)}');
    GoRoute(
      path: '/hotel/:id',
      builder: (ctx, st) {
        final id = st.pathParameters['id']!;
        // Nếu bạn đã mở rộng HotelDetailScreen để nhận title/image (optional), có thể truyền như sau:
        // return HotelDetailScreen(
        //   id: id,
        //   title: st.uri.queryParameters['title'],
        //   imageUrl: st.uri.queryParameters['image'],
        // );
        // Nếu hiện tại màn chi tiết chỉ nhận id, giữ nguyên:
        return HotelDetailScreen(id: id);
      },
    ),

    GoRoute(
      path: '/booking',
      builder: (_, __) => const BookingScreen(),
    ),
  ],
);
