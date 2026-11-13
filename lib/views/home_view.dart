
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final documentos = context.watch<DocumentosViewModel>();
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Documentos'),
        actions: [
          IconButton(
            icon: Icon(
              auth.temaEscuro ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Alterar tema',
            onPressed: () {
              auth.alterarTema(!auth.temaEscuro);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthViewModel>().logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Arquivos Recentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: documentos.documentos.length,
                itemBuilder: (context, index) {
                  final documento = documentos.documentos[index];

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        documento.tipo == 'pdf'
                            ? Icons.picture_as_pdf
                            : Icons.description,
                        color: documento.tipo == 'pdf'
                            ? Colors.red
                            : Colors.blue,
                      ),
                      title: Text(documento.titulo),
                      subtitle: Text(documento.descricao),
                      trailing: const Icon(Icons.edit),
                    ),
                  );
                },
              ),
            ),

            const Divider(
              height: 30,
              thickness: 2,
            ),

            const Text(
              'Edição Rápida',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/editor');
                },
                icon: const Icon(Icons.edit_document),
                label: const Text('Abrir Editor de Documentos'),
              ),
            ),

            const Spacer(),

            const Center(
              child: Text(
                'Desenvolvido por Vitor Hugo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
