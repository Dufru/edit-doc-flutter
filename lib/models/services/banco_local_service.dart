
import '../usuario.dart';
import '../documento.dart';

class BancoDadosLocal {
  BancoDadosLocal._();

  static final BancoDadosLocal instance = BancoDadosLocal._();

  final List<Usuario> _usuarios = [];
  final List<Documento> _documentos = [];

  int _proximoId = 1;

  // =========================
  // USUÁRIOS
  // =========================

  Future<bool> inserirUsuario(Usuario usuario) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final emailExiste = _usuarios.any(
      (u) => u.email.toLowerCase() == usuario.email.toLowerCase(),
    );

    if (emailExiste) {
      return false;
    }

    _usuarios.add(
      Usuario(
        id: _proximoId++,
        nome: usuario.nome,
        email: usuario.email,
        senha: usuario.senha,
      ),
    );

    return true;
  }

  Future<List<Usuario>> consultarUsuarios() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return List.unmodifiable(_usuarios);
  }

  Future<Usuario?> autenticarUsuario(
    String email,
    String senha,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _usuarios.firstWhere(
        (usuario) =>
            usuario.email.toLowerCase() == email.toLowerCase() &&
            usuario.senha == senha,
      );
    } catch (_) {
      return null;
    }
  }

  // =========================
  // DOCUMENTOS
  // =========================

  Future<void> inserirDocumento(Documento documento) async {
    await Future.delayed(const Duration(milliseconds: 200));

    _documentos.add(documento);
  }

  Future<List<Documento>> consultarDocumentos() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return List.unmodifiable(_documentos);
  }

  Future<void> atualizarDocumento(Documento documento) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _documentos.indexWhere(
      (d) => d.id == documento.id,
    );

    if (index != -1) {
      _documentos[index] = documento;
    }
  }

  Future<void> excluirDocumento(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    _documentos.removeWhere((d) => d.id == id);
  }
}
