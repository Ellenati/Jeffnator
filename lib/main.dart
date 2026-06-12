import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/game_controller.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final gameController = GameController();
  await gameController.loadFromStorage();

  runApp(
    ChangeNotifierProvider.value(
      value: gameController,
      child: const AdivinhaProfApp(),
    ),
  );
}

class AdivinhaProfApp extends StatelessWidget {
  const AdivinhaProfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeffnator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A152C),
          primary: const Color(0xFF6A152C), // Explicitly enforcing the primary color
        ),
        useMaterial3: true,
        // Optional: Apply a clean global AppBar theme matching the new colors
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color(0xFF6A152C)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
