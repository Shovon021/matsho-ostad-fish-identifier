import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _notificationsEnabledKey = 'notifications_enabled';

  // Bangla fish facts with English translations
  static const List<Map<String, String>> fishFacts = [
    {
      'bn': 'ইলিশ মাছ লবণাক্ত পানি থেকে মিঠা পানিতে ডিম পাড়তে আসে।',
      'en': 'Hilsa fish migrate from salt water to fresh water to spawn.',
    },
    {
      'bn': 'রুই মাছ বাংলাদেশের সবচেয়ে জনপ্রিয় মাছগুলোর একটি।',
      'en': 'Rohu is one of the most popular fish in Bangladesh.',
    },
    {
      'bn': 'পাবদা মাছ রাতে বেশি সক্রিয় থাকে।',
      'en': 'Pabda fish are more active at night.',
    },
    {
      'bn': 'কাতলা মাছ ৩০ কেজি পর্যন্ত ওজন হতে পারে।',
      'en': 'Catla fish can weigh up to 30 kg.',
    },
    {
      'bn': 'মৃগেল মাছ নদীর তলদেশে বসবাস করে।',
      'en': 'Mrigal fish live at the bottom of rivers.',
    },
    {
      'bn': 'বোয়াল মাছ একটি শিকারি মাছ যা অন্য মাছ খায়।',
      'en': 'Boal is a predatory fish that eats other fish.',
    },
    {
      'bn': 'চিংড়ি বাংলাদেশের প্রধান রপ্তানি পণ্যগুলোর একটি।',
      'en': 'Shrimp is one of Bangladesh\'s major export products.',
    },
    {
      'bn': 'তেলাপিয়া মাছ দ্রুত বৃদ্ধি পায় এবং চাষযোগ্য।',
      'en': 'Tilapia fish grow fast and are easy to farm.',
    },
    {
      'bn': 'পাঙ্গাস মাছের তেল হৃদপিণ্ডের জন্য উপকারী।',
      'en': 'Pangasius fish oil is beneficial for the heart.',
    },
    {
      'bn': 'শোল মাছ স্থলভাগে কিছু সময় বেঁচে থাকতে পারে।',
      'en': 'Snakehead fish can survive on land for some time.',
    },
  ];

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);

    if (enabled) {
      await scheduleDailyFishFact();
    } else {
      await cancelAllNotifications();
    }
  }

  Future<void> scheduleDailyFishFact() async {
    await cancelAllNotifications();

    // Schedule for 9:00 AM daily
    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9, // 9 AM
      0,
    );

    // If 9 AM has passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    // Get random fish fact
    final random = Random();
    final fact = fishFacts[random.nextInt(fishFacts.length)];

    await _notifications.zonedSchedule(
      1,
      '🐟 দৈনিক মাছের তথ্য',
      fact['bn']!,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_fish_facts',
          'Daily Fish Facts',
          channelDescription: 'Daily interesting facts about fish',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Show an instant test notification
  Future<void> showTestNotification() async {
    final random = Random();
    final fact = fishFacts[random.nextInt(fishFacts.length)];

    await _notifications.show(
      0,
      '🐟 মৎস্য ওস্তাদ',
      fact['bn']!,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_fish_facts',
          'Daily Fish Facts',
          channelDescription: 'Daily interesting facts about fish',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
