import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/widgets/mobile_wrapper.dart';
import 'core/widgets/animated_splash_screen.dart';
import 'core/services/notification_service.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found or invalid: $e");
  }
  
  if (kIsWeb) {
    // Initialize FFI for web
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Initialize notifications (not on web)
  if (!kIsWeb) {
    await NotificationService().initialize();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme provider for changes
    final currentThemeType = ref.watch(themeProvider);
    final themeColors = getThemeColors(currentThemeType);
    
    return MaterialApp(
      title: 'Matsho Ostad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromThemeColors(themeColors),
      darkTheme: AppTheme.fromThemeColors(themeColors),
      themeMode: ThemeMode.dark, // Always dark mode for our deep ocean aesthetic
      home: const MobileWrapper(child: AnimatedSplashScreen()),
      builder: (context, child) {
        return MobileWrapper(child: child!);
      },
    );
  }
}

