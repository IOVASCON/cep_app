// lib/ui/widgets/cep_form.dart (CORRETO - sem const no ElevatedButton)
import 'package:flutter/material.dart';
import '../../data/models/cep_model.dart';

class CepForm extends StatelessWidget {
  final Cep cep;
  final bool isUpdate;
  final VoidCallback onSave;

  const CepForm({
    super.key,
    required this.cep,
    required this.isUpdate,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final cepController = TextEditingController(text: cep.cep);
    final logradouroController = TextEditingController(text: cep.logradouro);
    final complementoController = TextEditingController(text: cep.complemento);
    final bairroController = TextEditingController(text: cep.bairro);
    final localidadeController = TextEditingController(text: cep.localidade);
    final ufController = TextEditingController(text: cep.uf);
    final ibgeController = TextEditingController(text: cep.ibge);
    final giaController = TextEditingController(text: cep.gia);
    final dddController = TextEditingController(text: cep.ddd);
    final siafiController = TextEditingController(text: cep.siafi);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: cepController,
              decoration: const InputDecoration(labelText: 'CEP'), // const
              enabled: false),
          TextField(
              controller: logradouroController,
              decoration:
                  const InputDecoration(labelText: 'Logradouro')), // const
          TextField(
              controller: complementoController,
              decoration:
                  const InputDecoration(labelText: 'Complemento')), // const
          TextField(
              controller: bairroController,
              decoration: const InputDecoration(labelText: 'Bairro')), // const
          TextField(
              controller: localidadeController,
              decoration:
                  const InputDecoration(labelText: 'Localidade')), // const
          TextField(
              controller: ufController,
              decoration: const InputDecoration(labelText: 'UF')), // const
          TextField(
              controller: ibgeController,
              decoration: const InputDecoration(labelText: 'IBGE')), // const
          TextField(
              controller: giaController,
              decoration: const InputDecoration(labelText: 'GIA')), // const
          TextField(
              controller: dddController,
              decoration: const InputDecoration(labelText: 'DDD')), // const
          TextField(
              controller: siafiController,
              decoration: const InputDecoration(labelText: 'SIAFI')), // const
          ElevatedButton(
            // Sem const aqui!
            onPressed: () {
              cep.logradouro = logradouroController.text;
              cep.complemento = complementoController.text;
              cep.bairro = bairroController.text;
              cep.localidade = localidadeController.text;
              cep.uf = ufController.text;
              cep.ibge = ibgeController.text;
              cep.gia = giaController.text;
              cep.ddd = dddController.text;
              cep.siafi = siafiController.text;

              onSave();
            },
            child:
                Text(isUpdate ? 'Salvar' : 'Adicionar'), // const aqui está OK
          ),
        ],
      ),
    );
  }
}
