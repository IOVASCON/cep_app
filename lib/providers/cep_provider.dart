// lib/providers/cep_provider.dart (VERSÃO DEFINITIVA E CORRETA)
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../data/models/cep_model.dart';
import '../data/repositories/cep_repository.dart';

class CepProvider with ChangeNotifier {
  final CepRepository _repository = CepRepository();
  final _logger = Logger();

  List<Cep> _ceps = [];
  bool _isLoading = false;
  String? _errorMessage;
  Cep? _selectedCep;

  List<Cep> get ceps => _ceps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Cep? get selectedCep => _selectedCep;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadCeps() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ceps = await _repository.getAllCeps();
    } catch (e) {
      _errorMessage = e.toString();
      _logger.e("Erro em loadCeps", error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrUpdateCep(BuildContext context, Cep cep,
      {bool isUpdate = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (isUpdate) {
        await _repository.updateCep(cep);
        final index = _ceps.indexWhere((c) => c.objectId == cep.objectId);
        if (index != -1) {
          _ceps[index] = cep;
        }
      } else {
        final addedCep = await _repository.addCep(cep);
        _ceps.add(addedCep);
      }

      if (!context.mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      _errorMessage = e.toString();
      _logger.e("Erro em addOrUpdateCep", error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCep(String objectId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.deleteCep(objectId);
      _ceps.removeWhere((cep) => cep.objectId == objectId);
    } catch (e) {
      _errorMessage = e.toString();
      _logger.e("Erro em deleteCep", error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCep(BuildContext context, String cepString) async {
    if (cepString.isEmpty || cepString.length < 8) {
      _errorMessage = "CEP inválido.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String cleanCep = cepString.replaceAll(RegExp(r'[^0-9]'), '');
      Cep? cep = await _repository.getCepByCep(cleanCep);

      if (cep != null) {
        if (!context.mounted) return;
        editCep(context, cep);
      } else {
        cep = await _repository.searchCepOnViaCep(cleanCep);

        if (!context.mounted) return;
        if (cep != null) {
          _showCepDialog(context, cep, isUpdate: false);
        } else {
          _errorMessage = "CEP não encontrado.";
          notifyListeners();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      _logger.e("Erro em searchCep", error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showCepDialog(BuildContext context, Cep cep, {bool isUpdate = false}) {
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

    showDialog(
      // Sem const aqui
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdate ? 'Editar CEP' : 'Adicionar CEP'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  // Sem const aqui
                  controller: cepController,
                  decoration: const InputDecoration(labelText: 'CEP'), // const
                  enabled: false,
                ),
                TextField(
                  // Sem const aqui
                  controller: logradouroController,
                  decoration:
                      const InputDecoration(labelText: 'Logradouro'), // const
                ),
                TextField(
                  // Sem const aqui
                  controller: complementoController,
                  decoration:
                      const InputDecoration(labelText: 'Complemento'), // const
                ),
                TextField(
                  // Sem const aqui
                  controller: bairroController,
                  decoration:
                      const InputDecoration(labelText: 'Bairro'), // const
                ),
                TextField(
                  // Sem const aqui
                  controller: localidadeController,
                  decoration:
                      const InputDecoration(labelText: 'Localidade'), // const
                ),
                TextField(
                  // Sem const aqui
                  controller: ufController,
                  decoration: const InputDecoration(labelText: 'UF'), // const
                ),
                TextField(
                  // Sem const aqui
                  controller: ibgeController,
                  decoration: const InputDecoration(labelText: 'IBGE'), // const
                ),
                TextField(
                  // Sem const aqui
                  controller: giaController,
                  decoration: const InputDecoration(labelText: 'GIA'), // const
                ),
                TextField(
                  // Sem const aqui
                  controller: dddController,
                  decoration: const InputDecoration(labelText: 'DDD'), // const
                ),
                TextField(
                  // Sem const aqui
                  controller: siafiController,
                  decoration:
                      const InputDecoration(labelText: 'SIAFI'), // const
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              // Sem const aqui
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'), // const
            ),
            TextButton(
              // Sem const aqui
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

                addOrUpdateCep(context, cep, isUpdate: isUpdate);
              },
              child: Text(isUpdate ? 'Salvar' : 'Adicionar'), // const
            ),
          ],
        );
      },
    );
  }

  void editCep(BuildContext context, Cep cep) {
    _selectedCep = cep;
    _showCepDialog(context, cep, isUpdate: true);
    notifyListeners();
  }
}
