
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesService {
  static const String _temaKey = 'tema_aplicativo';
  static const String _notificacoesKey = 'notificacoes_ativadas';

  Future<void> salvarTema(ThemeMode tema) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _temaKey,
      tema == ThemeMode.dark ? 'escuro' : 'claro',
    );
  }

  Future<ThemeMode> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();

    final tema = prefs.getString(_temaKey);

    return tema == 'escuro'
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  Future<void> salvarNotificacoes(bool ativadas) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_notificacoesKey, ativadas);
  }

  Future<bool> carregarNotificacoes() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_notificacoesKey) ?? true;
  }
}
