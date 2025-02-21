import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cep_provider.dart';
import '../widgets/cep_list_item.dart';

class CepListPage extends StatefulWidget {
  const CepListPage({super.key});

  @override
  State<CepListPage> createState() => _CepListPageState();
}

class _CepListPageState extends State<CepListPage> {
  final _cepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CepProvider>(context, listen: false).loadCeps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de CEPs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _cepController,
              decoration: InputDecoration(
                labelText: 'Buscar CEP',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Correção: Passar APENAS a string do CEP:
                    Provider.of<CepProvider>(context, listen: false)
                        .searchCep(context, _cepController.text); // CORRIGIDO
                  },
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            child: Consumer<CepProvider>(
              builder: (context, cepProvider, child) {
                if (cepProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (cepProvider.errorMessage != null) {
                  return _buildErrorMessage(cepProvider);
                }

                if (cepProvider.ceps.isEmpty) {
                  return const Center(child: Text('Nenhum CEP cadastrado.'));
                }

                return ListView.builder(
                  itemCount: cepProvider.ceps.length,
                  itemBuilder: (context, index) {
                    final cep = cepProvider.ceps[index];
                    return CepListItem(cep: cep);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(CepProvider cepProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Erro: ${cepProvider.errorMessage}",
          style: const TextStyle(color: Colors.red),
        ),
        ElevatedButton(
          onPressed: () {
            cepProvider.clearError();
            cepProvider.loadCeps();
          },
          child: const Text("Tentar novamente"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }
}
