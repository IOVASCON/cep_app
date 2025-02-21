import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cep_model.dart';
import '../../providers/cep_provider.dart';

class CepListItem extends StatelessWidget {
  final Cep cep;

  const CepListItem({super.key, required this.cep});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cep.cep),
      subtitle: Text('${cep.logradouro}, ${cep.localidade} - ${cep.uf}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // CORRIGIDO: Chamar editCep, passando o contexto e o CEP:
              Provider.of<CepProvider>(context, listen: false)
                  .editCep(context, cep);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<CepProvider>(context, listen: false)
                  .deleteCep(cep.objectId!);
            },
          ),
        ],
      ),
    );
  }
}
