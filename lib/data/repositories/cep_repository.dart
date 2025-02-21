import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cep_model.dart';
import '../services/viacep_service.dart';

class CepRepository {
  final ViaCepService _viaCepService = ViaCepService();
  final String _baseUrl = 'https://parseapi.back4app.com/classes';
  final String _appId =
      'ztyZS9gXJy0nv9S6XMiKBZCw13xBYddyiwJ55TqJ'; // Substitua pelo seu Application ID
  final String _restApiKey =
      'NKD4vY619ZjlVKoyR3BWf4K51I5Vr6aXCf7QVasn'; // Substitua pela sua REST API Key

  Future<List<Cep>> getAllCeps() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/Cep'), //  '/Cep' = nome da sua classe no Back4App
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((item) => Cep.fromJsonBack4App(item)).toList();
    } else {
      throw Exception(
        'Erro ao buscar CEPs: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Cep?> getCepByCep(String cep) async {
    String cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');

    final response = await http.get(
      Uri.parse('$_baseUrl/Cep?where={"cep":"$cleanCep"}'),
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      if (results.isNotEmpty) {
        return Cep.fromJsonBack4App(results.first);
      } else {
        return null;
      }
    } else {
      throw Exception(
        'Erro ao buscar CEP: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Cep> addCep(Cep cep) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/Cep'),
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(cep.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      cep.objectId = data['objectId'];
      return cep;
    } else {
      throw Exception(
        'Erro ao adicionar CEP: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Cep> updateCep(Cep cep) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/Cep/${cep.objectId}'),
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(cep.toJson()),
    );

    if (response.statusCode == 200) {
      return cep;
    } else {
      throw Exception(
        'Erro ao atualizar CEP: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> deleteCep(String objectId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/Cep/$objectId'),
      headers: {
        'X-Parse-Application-Id': _appId,
        'X-Parse-REST-API-Key': _restApiKey,
        'Content-Type': 'application/json', // Add content type for DELETE
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao excluir CEP: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Cep?> searchCepOnViaCep(String cep) async {
    return await _viaCepService.getCep(cep);
  }
}
