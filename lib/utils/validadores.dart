
String? validarNome(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'O nome é obrigatório';
  }
  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'O e-mail é obrigatório';
  }

  if (!value.contains('@') || !value.contains('.')) {
    return 'Insira um e-mail válido';
  }

  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'A senha é obrigatória';
  }

  if (value.length < 6) {
    return 'A senha deve ter no mínimo 6 caracteres';
  }

  return null;
}
