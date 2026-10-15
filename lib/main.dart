import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'state/booking_controller.dart';
import 'screens/shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = BookingController();
  await controller.initialize();
  runApp(NivoraApp(controller: controller));
}

class NivoraApp extends StatelessWidget {
  final BookingController controller;
  const NivoraApp({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: controller,
    builder: (context, _) => MaterialApp(
      title: 'Nivora Booking',
      debugShowCheckedModeBanner: false,
      theme: makeTheme(false),
      darkTheme: makeTheme(true),
      themeMode: controller.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeShell(controller: controller),
    ));
}
