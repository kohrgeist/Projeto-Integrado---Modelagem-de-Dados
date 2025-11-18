import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_service.dart';
import '../models/leitura_tratada.dart';

/// Serviço para buscar dados do Firebase via polling (requisições HTTP GET)
class FirebaseService {
  final String firebaseDatabaseUrl;
  final String firebaseSecret;
  final DatabaseService databaseService;
  final http.Client _client;

  FirebaseService({
    required this.firebaseDatabaseUrl,
    required this.firebaseSecret,
    required this.databaseService,
  }) : _client = http.Client();

  /// Busca os dados do Firebase e insere no MySQL
  Future<void> buscarEInserirLeitura() async {
    final url = Uri.parse(
      '$firebaseDatabaseUrl/medidor.json?auth=$firebaseSecret',
    );

    try {
      print('[Firebase] Realizando requisição GET...');
      final response = await _client.get(url);

      if (response.statusCode != 200) {
        throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
      }

      final dados = jsonDecode(response.body);

      if (dados == null) {
        print('[Firebase] Nenhum dado disponível no nó /medidor.');
        return;
      }

      if (dados is! Map<String, dynamic>) {
        print('[Firebase] Formato de dados inesperado.');
        return;
      }

      print('[Firebase] Dados recebidos: $dados');

      // Converte e salva
      final leitura = LeituraTratada.fromFirebaseMap(dados);
      await databaseService.salvarLeitura(leitura);

      print('[OK] Leitura inserida no MySQL com sucesso!');
    } catch (e) {
      print('[ERRO] Falha ao buscar/inserir dados: $e');
      rethrow;
    }
  }

  /// Fecha o cliente HTTP
  void dispose() {
    _client.close();
  }
}
