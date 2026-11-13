
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../documento.dart';

class DocumentoStorageService {
  static const String _chaveDocumentos = 'documentos_salvos';

  Future<List<Documento>> carregarDocumentos() async {
    final preferencias = await SharedPreferences.getInstance();

    final dados = preferencias.getString(_chaveDocumentos);

    if (dados == null || dados.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> listaJson = jsonDecode(dados);

      return listaJson.map((item) {
        return Documento.fromMap(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();
    } catch (e) {
      throw Exception('Não foi possível carregar os documentos: $e');
    }
  }

  Future<void> salvarDocumentos(List<Documento> documentos) async {
    final preferencias = await SharedPreferences.getInstance();

    final listaJson = documentos.map((documento) {
      return documento.toMap();
    }).toList();

    final json = jsonEncode(listaJson);

    final sucesso = await preferencias.setString(
      _chaveDocumentos,
      json,
    );

    if (!sucesso) {
      throw Exception('Não foi possível salvar os documentos.');
    }
  }

  Future<void> limparDocumentos() async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.remove(_chaveDocumentos);
  }
}
