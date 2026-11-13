
import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../models/services/banco_local_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final BancoLocalService _banco = BancoLocalService();

  List<Documento> get documentos => _banco.documentos;
}
