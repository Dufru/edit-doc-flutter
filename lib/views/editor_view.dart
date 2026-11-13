
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/documento.dart';
import '../viewmodels/documentos_viewmodel.dart';

class EditorView extends StatefulWidget {
  final Documento? documento;

  const EditorView({
    super.key,
    this.documento,
  });

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _conteudoController;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(
      text: widget.documento?.titulo ?? '',
    );

    _conteudoController = TextEditingController(
      text: widget.documento?.conteudo ?? '',
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _salvando = true;
    });

    try {
      await context.read<DocumentosViewModel>().salvarDocumento(
        id: widget.documento?.id,
        titulo: _tituloController.text.trim(),
        conteudo: _conteudoController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Documento salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar documento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.documento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? 'Editar documento' : 'Novo documento',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o título do documento.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _conteudoController,
                minLines: 12,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Conteúdo',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  hintText: 'Escreva seu documento aqui...',
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'O conteúdo não pode ficar vazio.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _salvando ? null : _salvar,
                  icon: _salvando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _salvando ? 'Salvando...' : 'Salvar documento',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
