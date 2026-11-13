
String? validarNome(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'O nome é obrigatório';
  }

  if (value.trim().length < 3) {
    return 'Informe um nome com pelo menos 3 caracteres';
  }

  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'O e-mail é obrigatório';
  }

  final email = value.trim().toLowerCase();

  if (!email.contains('@')) {
    return 'O e-mail precisa conter @';
  }

  final partes = email.split('@');

  if (partes.length != 2 ||
      partes[0].isEmpty ||
      partes[1].isEmpty) {
    return 'Insira um e-mail válido';
  }

  if (!partes[1].endsWith('.com') &&
      !partes[1].endsWith('.com.br')) {
    return 'O e-mail deve terminar em .com ou .com.br';
  }

  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.isEmpty) {
    return 'A senha é obrigatória';
  }

  if (value.length < 6) {
    return 'A senha deve ter no mínimo 6 caracteres';
  }

  return null;
}
