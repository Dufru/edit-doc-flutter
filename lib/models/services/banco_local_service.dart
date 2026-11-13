
import '../usuario.dart';
import '../documento.dart';

class BancoLocalService {
  Usuario? _usuario;

  final List<Documento> _documentos = [
    Documento(
      titulo: 'Certificado_de_Conclusão.pdf',
      descricao: 'Aberto há 2 horas',
      tipo: 'pdf',
    ),
    Documento(
      titulo: 'Relatório_Trabalho_Unex.txt',
      descricao: 'Editado ontem',
      tipo: 'txt',
    ),
  ];

  Usuario? get usuario => _usuario;

  List<Documento> get documentos => List.unmodifiable(_documentos);

  void cadastrarUsuario(Usuario usuario) {
    _usuario = usuario;
  }
}
