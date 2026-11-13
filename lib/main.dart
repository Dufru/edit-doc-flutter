import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/documento.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';

import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/editor_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = AuthViewModel();
  await auth.inicializar();

  runApp(MyApp(auth: auth));
}

class MyApp extends StatelessWidget {
  final AuthViewModel auth;

  const MyApp({
    super.key,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(
          value: auth,
        ),
        ChangeNotifierProvider<DocumentosViewModel>(
          create: (_) => DocumentosViewModel()..carregarDocumentos(),
        ),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Biblioteca Digital',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: auth.tema,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (_) => const LoginView(),
                  );

                case '/cadastro':
                  return MaterialPageRoute(
                    builder: (_) => const CadastroView(),
                  );

                case '/home':
                  final nomeUsuario = settings.arguments as String;

                  return MaterialPageRoute(
                    builder: (_) => HomeView(
                      nomeUsuario: nomeUsuario,
                    ),
                  );

                case '/editor':
                  final documento = settings.arguments as Documento?;

                  return MaterialPageRoute(
                    builder: (_) => EditorView(
                      documento: documento,
                    ),
                  );

                default:
                  return MaterialPageRoute(
                    builder: (_) => const LoginView(),
                  );
              }
            },
          );
        },
      ),
    );
  }
}