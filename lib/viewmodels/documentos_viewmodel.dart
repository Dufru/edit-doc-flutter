
import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../models/services/documento_storage_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final DocumentoStorageService _storage =
      DocumentoStorageService();

  List<Documento> _documentos = [];

  bool _carregando = false;
  String? _erro;

  List<Documento> get documentos => List.unmodifiable(_documentos);

  bool get carregando => _carregando;

  String? get erro => _erro;

  Future<void> carregarDocumentos() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _documentos = await _storage.carregarDocumentos();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> salvarDocumento({
    String? id,
    required String titulo,
    required String conteudo,
  }) async {
    final agora = DateTime.now();

    if (id == null) {
      // CREATE: cria um novo documento.
      final novoDocumento = Documento(
        id: agora.microsecondsSinceEpoch.toString(),
        titulo: titulo,
        conteudo: conteudo,
        dataCriacao: agora,
        dataAtualizacao: agora,
      );

      _documentos = [..._documentos, novoDocumento];
    } else {
      // UPDATE: atualiza um documento existente.
      final indice = _documentos.indexWhere(
        (documento) => documento.id == id,
      );

      if (indice == -1) {
        throw Exception('Documento não encontrado.');
      }

      _documentos[indice] = _documentos[indice].copyWith(
        titulo: titulo,
        conteudo: conteudo,
        dataAtualizacao: agora,
      );

      _documentos = List.from(_documentos);
    }

    try {
      await _storage.salvarDocumentos(_documentos);
      _erro = null;
    } catch (e) {
      _erro = e.toString();
      rethrow;
    }

    notifyListeners();
  }

  Future<void> excluirDocumento(String id) async {
    final documentosAnteriores = List<Documento>.from(_documentos);

    // DELETE: remove o documento da lista.
    _documentos = _documentos.where(
      (documento) => documento.id != id,
    ).toList();

    try {
      await _storage.salvarDocumentos(_documentos);
      _erro = null;
    } catch (e) {
      _documentos = documentosAnteriores;
      _erro = e.toString();
      notifyListeners();
      rethrow;
    }

    notifyListeners();
  }
}
