// lib/app.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ui_kit_hotel/core/router/app_router.dart';
import 'package:flutter_ui_kit_hotel/core/theme/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (_, theme, __) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Hotel UI Kit',
            theme: AppTheme.light(GoogleFonts.plusJakartaSansTextTheme()),
            darkTheme: AppTheme.dark(GoogleFonts.plusJakartaSansTextTheme()),
            themeMode: theme.mode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
