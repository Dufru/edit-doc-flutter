
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edit_doc_flutter/main.dart';
import 'package:edit_doc_flutter/viewmodels/auth_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Aplicativo inicia e exibe a tela de login',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final auth = AuthViewModel();
    await auth.inicializar();

    await tester.pumpWidget(
      MyApp(auth: auth),
    );

    await tester.pumpAndSettle();

    expect(find.text('Biblioteca Digital'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
