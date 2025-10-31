import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'database_service.dart';
import '../models/leitura_tratada.dart';

class FirebaseListener {
  final String firebaseDatabaseUrl;
  final String firebaseSecret;
  final DatabaseService databaseService;
  final http.Client _client;

  Map<String, dynamic>? _cachedData;
  FirebaseListener({
    required this.firebaseDatabaseUrl,
    required this.firebaseSecret,
    required this.databaseService,
  }) : _client = http.Client();

  Future<void> listen() async {
    final url = Uri.parse(
      '$firebaseDatabaseUrl/medidor.json?auth=$firebaseSecret',
    );

    final request = http.Request('GET', url);
    request.headers['Accept'] = 'text/event-stream';
    print(
      '[FIREBASE] Conectando ao Firebase Realtime Database em /leitura_sensor...',
    );

    try {
      final response = await _client.send(request);
      if (response.statusCode != 200) {
        throw Exception('Falha ao conectar: ${response.statusCode}');
      }
      print('[FIREBASE] Conectado! Ouvindo novos dados...');
      final completer = Completer<void>();
      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => _processarLinhaSSE(line),
            onDone: () => completer.complete(),
            onError: (e) => completer.completeError(e),
            cancelOnError: true,
          );
      await completer.future;
    } catch (e) {
      print('[FIREBASE] Erro de conexão: $e');
      rethrow;
    }
  }

  String? _currentEvent;
  String? _currentData;

  void _processarLinhaSSE(String line) {
    if (line.startsWith('event:')) {
      _currentEvent = line.substring(6).trim();
    } else if (line.startsWith('data:')) {
      _currentData = line.substring(5).trim();
    } else if (line.isEmpty && _currentEvent != null && _currentData != null) {
      _processarEvento(_currentEvent!, _currentData!);
      _currentEvent = null;
      _currentData = null;
    }
  }

  //put como evento principal e patch para atualização parcial que o sensor envia
  void _processarEvento(String event, String data) {
    if (event == 'keep-alive') return;
    if (event != 'put' && event != 'patch') return;

    try {
      final payload = jsonDecode(data);
      final dynamic dados = payload['data'];

      if (dados == null) {
        print('[FIREBASE] Nó /medidor foi deletado.');
        _cachedData = null;
        return;
      }

      if (dados is! Map<String, dynamic>) {
        print('[FIREBASE] Dados em formato inesperado. Ignorando.');
        return;
      }

      if (event == 'put') {
        // Evento 'put' = objeto completo. Ele vira o novo cache.
        _cachedData = dados;
        print('[FIREBASE] (PUT) Leitura completa recebida.');
      } else if (event == 'patch') {
        // Evento 'patch' = dados parciais/atualização
        if (_cachedData == null) {
          print(
            '[FIREBASE] (PATCH) Recebido, mas cache está vazio. Aguardando um PUT inicial.',
          );
          return;
        }
        _cachedData!.addAll(dados);
        print('[FIREBASE] (PATCH) Atualização de campo recebida.');
      }

      if (_cachedData != null) {
        print('[FIREBASE] Processando dados mesclados: $_cachedData');
        final leitura = LeituraTratada.fromFirebaseMap(_cachedData!);
        databaseService.salvarLeitura(leitura);
      }
    } catch (e) {
      print('[FIREBASE] Erro ao processar dados do evento: $e. Dados: $data');
    }
  }
}
