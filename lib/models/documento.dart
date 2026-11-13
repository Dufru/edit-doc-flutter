
class Documento {
  final String id;
  final String titulo;
  final String conteudo;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  Documento({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'conteudo': conteudo,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataAtualizacao': dataAtualizacao.toIso8601String(),
    };
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      conteudo: map['conteudo'] as String,
      dataCriacao: DateTime.parse(map['dataCriacao'] as String),
      dataAtualizacao:
          DateTime.parse(map['dataAtualizacao'] as String),
    );
  }

  Documento copyWith({
    String? titulo,
    String? conteudo,
    DateTime? dataAtualizacao,
  }) {
    return Documento(
      id: id,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      dataCriacao: dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
