import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Adicionei as páginas.

import 'screens/auth_screen.dart';
import 'screens/calendar_screen.dart';
import 'services/app_storage.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.instance.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
  );
  runApp(const DiaDiaApp());
}

class DiaDiaApp extends StatelessWidget {
  const DiaDiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = AppStorage.instance.currentUser != null;
    return MaterialApp(
      title: 'DiaDia',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: loggedIn ? const CalendarScreen() : const AuthScreen(),
    );
  }
}
