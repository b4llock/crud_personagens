import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/missao_service.dart';

const _pergaminho = Color(0xFF241B13);
const _borda = Color(0xFF5A452A);
const _ouro = Color(0xFFD4A94A);
const _textoClaro = Color(0xFFEADBB8);

class MissoesScreen extends StatefulWidget {
  const MissoesScreen({super.key});

  @override
  State<MissoesScreen> createState() => _MissoesScreenState();
}

class _MissoesScreenState extends State<MissoesScreen> {
  final _service = MissaoService();
  final _tituloController = TextEditingController();
  bool _salvando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) return;

    setState(() => _salvando = true);
    try {
      await _service.registrarConclusao(titulo);
      if (mounted) _tituloController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar a missão: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
          child: Column(
            children: [
              TextField(
                controller: _tituloController,
                style: const TextStyle(color: _textoClaro),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!_salvando) _registrar();
                },
                decoration: const InputDecoration(
                  labelText: 'Missão concluída',
                  hintText: 'Ex: Derrotar o dragão',
                  prefixIcon: Icon(Icons.flag, color: _ouro),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvando ? null : _registrar,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(_salvando ? 'SALVANDO...' : 'REGISTRAR CONCLUSÃO'),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'MISSÕES CONCLUÍDAS',
            style: TextStyle(
              color: _ouro,
              letterSpacing: 2,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _service.listarMissoes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar missões: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: _ouro));
              }

              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhuma missão concluída ainda.',
                    style: TextStyle(color: _textoClaro),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final dados = docs[index].data();
                  final concluidaEm = dados['concluidaEm'] as Timestamp?;
                  final data = concluidaEm?.toDate().toLocal();
                  final dataTexto = data == null
                      ? 'Salvando data...'
                      : '${data.day.toString().padLeft(2, '0')}/'
                            '${data.month.toString().padLeft(2, '0')}/'
                            '${data.year}';

                  return Card(
                    color: _pergaminho,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: _borda),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.task_alt, color: _ouro),
                      title: Text(
                        dados['titulo'] as String? ?? '',
                        style: const TextStyle(color: _textoClaro),
                      ),
                      subtitle: Text(dataTexto),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
