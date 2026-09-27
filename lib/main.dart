import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:provider/provider.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/reminder_controller.dart';

// Instancia global para usar desde cualquier parte de la app
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar zonas horarias (necesario para alarmas exactas)
  tz.initializeTimeZones();

final TimezoneInfo timeZoneInfo = await FlutterTimezone.getLocalTimezone();
tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
  // 2. Inicializar el plugin de notificaciones
  await _initNotifications();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ReminderController()..load(),
      child: const WarmHearthApp(),
    ),
  );
}

// Función separada para mantener el main limpio
Future<void> _initNotifications() async {
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

  await flutterLocalNotificationsPlugin.initialize(
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint('Notificación tocada: ${response.payload}');
    },
    settings: initSettings,
  );

  // 3. Pedir permiso de notificaciones en Android 13+ (obligatorio)
  final androidImpl = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await androidImpl?.requestNotificationsPermission();

  // 4. Pedir permiso de alarmas exactas (Android 12+)
  final canScheduleExact = await androidImpl?.canScheduleExactNotifications();
  if (canScheduleExact == false) {
    // Esto abre la pantalla de ajustes del sistema para que el usuario lo active
    await androidImpl?.requestExactAlarmsPermission();
  }
}

class WarmHearthApp extends StatelessWidget {
  const WarmHearthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warm Hearth & Rhythm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}