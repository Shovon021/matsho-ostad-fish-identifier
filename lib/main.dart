import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/mobile_wrapper.dart';
import 'core/widgets/animated_splash_screen.dart';
import 'core/services/notification_service.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matsho Ostad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MobileWrapper(child: AnimatedSplashScreen()),
      builder: (context, child) {
        return MobileWrapper(child: child!);
      },
    );
  }
}
