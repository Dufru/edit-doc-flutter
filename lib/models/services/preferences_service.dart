
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _temaKey = 'tema_escuro';

  Future<bool> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_temaKey) ?? false;
  }

  Future<void> salvarTema(bool temaEscuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_temaKey, temaEscuro);
  }
}
