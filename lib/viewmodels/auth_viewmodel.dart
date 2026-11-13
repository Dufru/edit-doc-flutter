
import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();

  bool _logado = false;
  bool _temaEscuro = false;

  bool get logado => _logado;
  bool get temaEscuro => _temaEscuro;

  AuthViewModel() {
    carregarPreferencias();
  }

  Future<void> carregarPreferencias() async {
    _temaEscuro = await _preferencesService.carregarTema();
    notifyListeners();
  }

  Future<void> alterarTema(bool valor) async {
    _temaEscuro = valor;
    await _preferencesService.salvarTema(valor);
    notifyListeners();
  }

  bool login(String email, String senha) {
    if (email.trim().isNotEmpty && senha.length >= 6) {
      _logado = true;
      notifyListeners();
      return true;
    }

    return false;
  }

  bool cadastrar(Usuario usuario) {
    if (usuario.nome.trim().isNotEmpty &&
        usuario.email.trim().isNotEmpty &&
        usuario.senha.length >= 6) {
      return true;
    }

    return false;
  }

  void logout() {
    _logado = false;
    notifyListeners();
  }
}
