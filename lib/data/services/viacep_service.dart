import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cep_model.dart';

class ViaCepService {
  Future<Cep?> getCep(String cep) async {
    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('erro') && data['erro'] == true) {
          return null; // CEP não encontrado
        } else {
          return Cep.fromJsonViaCep(data);
        }
      } else {
        // Tratar erros de HTTP (status diferente de 200)
        throw Exception('Erro ao consultar o ViaCEP: ${response.statusCode}');
      }
    } catch (e) {
      // Tratar outras exceções (ex: problemas de rede)
      throw Exception('Exceção ao consultar o ViaCEP: $e');
    }
  }
}
