
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/usuario.dart';
import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatelessWidget {
  final String nomeUsuario;

  const HomeView({
    super.key,
    required this.nomeUsuario,
  });

  Future<void> _mostrarUsuarios(BuildContext context) async {
    final auth = context.read<AuthViewModel>();
    final List<Usuario> usuarios = await auth.consultarUsuarios();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Usuários cadastrados',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: usuarios.isEmpty
                      ? const Center(
                          child: Text('Nenhum usuário cadastrado.'),
                        )
                      : ListView.builder(
                          itemCount: usuarios.length,
                          itemBuilder: (context, index) {
                            final usuario = usuarios[index];

                            return ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(usuario.nome),
                              subtitle: Text(usuario.email),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarPreferencias(BuildContext context) {
    final auth = context.read<AuthViewModel>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            ThemeMode tema = auth.tema;
            bool notificacoes = auth.notificacoes;

            return AlertDialog(
              title: const Text('Preferências'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tema do aplicativo'),
                  RadioGroup<ThemeMode>(
                    groupValue: tema,
                    onChanged: (valor) async {
                      if (valor == null) return;

                      setDialogState(() {
                        tema = valor;
                      });

                      await auth.alterarTema(valor);
                    },
                    child: Column(
                      children: const [
                        RadioListTile<ThemeMode>(
                          title: Text('Claro'),
                          value: ThemeMode.light,
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<ThemeMode>(
                          title: Text('Escuro'),
                          value: ThemeMode.dark,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notificações'),
                    value: notificacoes,
                    onChanged: (valor) async {
                      setDialogState(() {
                        notificacoes = valor;
                      });

                      await auth.alterarNotificacoes(valor);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _abrirEditor(
    BuildContext context, {
    Documento? documento,
  }) {
    Navigator.pushNamed(
      context,
      '/editor',
      arguments: documento,
    );
  }

  Future<void> _excluirDocumento(
    BuildContext context,
    Documento documento,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir documento'),
          content: Text(
            'Deseja excluir "${documento.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !context.mounted) return;

    await context
        .read<DocumentosViewModel>()
        .excluirDocumento(documento.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento excluído.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca Digital'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthViewModel>().logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, $nomeUsuario!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Organize seus documentos em um só lugar.',
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _mostrarPreferencias(context),
                      child: const Padding(
                        padding: EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Icon(
                              Icons.settings,
                              size: 34,
                              color: Colors.indigo,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Preferências',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _mostrarUsuarios(context),
                      child: const Padding(
                        padding: EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people,
                              size: 34,
                              color: Colors.indigo,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Usuários',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meus documentos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  tooltip: 'Novo documento',
                  onPressed: () => _abrirEditor(context),
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Consumer<DocumentosViewModel>(
              builder: (context, documentosVM, child) {
                if (documentosVM.carregando) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (documentosVM.documentos.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Você ainda não possui documentos.\n'
                          'Toque no botão + para criar o primeiro.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documentosVM.documentos.length,
                  itemBuilder: (context, index) {
                    final documento =
                        documentosVM.documentos[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.description_outlined,
                          color: Colors.indigo,
                        ),
                        title: Text(documento.titulo),
                        subtitle: Text(
                          documento.conteudo,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          _abrirEditor(
                            context,
                            documento: documento,
                          );
                        },
                        trailing: PopupMenuButton<String>(
                          onSelected: (valor) {
                            if (valor == 'editar') {
                              _abrirEditor(
                                context,
                                documento: documento,
                              );
                            } else if (valor == 'excluir') {
                              _excluirDocumento(
                                context,
                                documento,
                              );
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'editar',
                              child: Text('Editar'),
                            ),
                            PopupMenuItem(
                              value: 'excluir',
                              child: Text('Excluir'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Desenvolvido por Vitor Hugo',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
