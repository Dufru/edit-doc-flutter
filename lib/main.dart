
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';

import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/editor_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => DocumentosViewModel(),
        ),
      ],

      child: Consumer<AuthViewModel>(
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'App de Documentos',

            debugShowCheckedModeBanner: false,

            themeMode: auth.temaEscuro
                ? ThemeMode.dark
                : ThemeMode.light,

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

            initialRoute: '/',

            routes: {
              '/': (context) => const LoginView(),

              '/cadastro': (context) => const CadastroView(),

              '/home': (context) => const HomeView(),

              '/editor': (context) => const EditorView(),
            },
          );
        },
      ),
    );
  }
}
