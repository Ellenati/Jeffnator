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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
