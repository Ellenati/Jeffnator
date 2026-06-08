import 'package:flutter_test/flutter_test.dart';
import 'package:adivinha_prof/main.dart';
import 'package:provider/provider.dart';
import 'package:adivinha_prof/controllers/game_controller.dart';

void main() {
  testWidgets('App starts and shows start button', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => GameController(),
        child: const AdivinhaProfApp(),
      ),
    );

    expect(find.text('Começar'), findsOneWidget);
    expect(find.text('Adivinha Prof'), findsOneWidget);
  });
}
