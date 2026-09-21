import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

// Instancia global para usar desde cualquier parte de la app
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar zonas horarias (necesario para alarmas exactas)
  tz.initializeTimeZones();

  // 2. Inicializar el plugin de notificaciones
  await _initNotifications();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const WarmHearthApp());
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
      // Aquí manejas qué pasa cuando el usuario toca la notificación
      // Por ahora vacío, luego puedes navegar a una pantalla específica
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
