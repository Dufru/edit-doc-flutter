
import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  final BancoDadosLocal _banco = BancoDadosLocal.instance;
  final PreferencesService _preferencias = PreferencesService();

  ThemeMode _tema = ThemeMode.light;
  bool _notificacoes = true;
  Usuario? _usuarioLogado;
  bool _carregando = false;

  ThemeMode get tema => _tema;
  bool get notificacoes => _notificacoes;
  Usuario? get usuarioLogado => _usuarioLogado;
  bool get carregando => _carregando;

  Future<void> inicializar() async {
    _tema = await _preferencias.carregarTema();
    _notificacoes = await _preferencias.carregarNotificacoes();

    notifyListeners();
  }

  Future<String?> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required ThemeMode tema,
    required bool notificacoes,
  }) async {
    _carregando = true;
    notifyListeners();

    try {
      final usuario = Usuario(
        nome: nome.trim(),
        email: email.trim().toLowerCase(),
        senha: senha,
      );

      final inserido = await _banco.inserirUsuario(usuario);

      if (!inserido) {
        return 'Este e-mail já está cadastrado.';
      }

      await _preferencias.salvarTema(tema);
      await _preferencias.salvarNotificacoes(notificacoes);

      _tema = tema;
      _notificacoes = notificacoes;

      return null;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<String?> login({
    required String email,
    required String senha,
  }) async {
    _carregando = true;
    notifyListeners();

    try {
      final usuario = await _banco.autenticarUsuario(
        email.trim(),
        senha,
      );

      if (usuario == null) {
        return 'E-mail ou senha incorretos.';
      }

      _usuarioLogado = usuario;

      return null;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<List<Usuario>> consultarUsuarios() async {
    return await _banco.consultarUsuarios();
  }

  Future<void> alterarTema(ThemeMode tema) async {
    _tema = tema;

    await _preferencias.salvarTema(tema);

    notifyListeners();
  }

  Future<void> alterarNotificacoes(bool valor) async {
    _notificacoes = valor;

    await _preferencias.salvarNotificacoes(valor);

    notifyListeners();
  }

  void logout() {
    _usuarioLogado = null;
    notifyListeners();
  }
}
