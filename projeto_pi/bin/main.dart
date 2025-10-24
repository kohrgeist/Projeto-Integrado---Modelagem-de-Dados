import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:mysql1/mysql1.dart';
import 'package:firedart/firedart.dart'; 
import 'dart:convert';
import 'dart:io';

// config do MySQL
final dbSettings = ConnectionSettings(
  host: 'IP_DO_SEU_MYSQL',
  port: 3306,
  user: 'seu_usuario',
  password: '1234',
  db: 'mydb',
);
//codigo genérico do MySQL, esperar o Isaque, não consigo utilizar o MySQL nesse pc ainda.

void main() async {
  // 1. Inicializa a conexão com o Firebase
  Firestore.initialize("pi2025-99c23");
  print("Conectado ao Firebase.");

  // 2. Define a variável handler pro servidor HTTP
  Future<Response> handler(Request request) async {
    if (request.url.path == 'leitura') {
      // 3. recebendo o dado bruto do ESP32
      var body = await request.readAsString();
      var jsonEsp = jsonDecode(body);
      print("Recebido do ESP32: $jsonEsp");

      // 4. conecta e consulta o MySQL para "enriquecer" o dado
      var conn = await MySqlConnection.connect(dbSettings);
      var results = await conn.query(
        'SELECT m.voltagem, m.idmaquina, m.nome AS nome_maquina '
        'FROM sensores s '
        'JOIN maquina m ON s.maquina_idmaquina = m.idmaquina '
        'WHERE s.idsensores = ?',
        [jsonEsp['idsensor']],
      );
      await conn.close();

      if (results.isEmpty) {
        return Response.notFound('Sensor não cadastrado no MySQL');
      }

      var infoSensor = results.first;
      double corrente = jsonEsp['corrente'];
      double voltagem = infoSensor['voltagem'];
      double potencia = corrente * voltagem;

      // 5. doc final pro Firebase
      var docFinal = {
        'idSensor': jsonEsp['idsensor'],
        'idMaquina': infoSensor['idmaquina'],
        'nomeMaquina': infoSensor['nome_maquina'],
        'valorCorrente': corrente,
        'valorPotencia': potencia,
        'dataHora': DateTime.now().toIso8601String(),
      };

      // 6. envio pro Firebase
      await Firestore.instance.collection('leituras').add(docFinal);
      print("Dado enriquecido enviado ao Firebase: $docFinal");

      return Response.ok('Dado recebido com sucesso!');
    }
    return Response.notFound('Endpoint não encontrado');
  }

  // 7. servidor na porta 8080
  var server = await io.serve(handler, '0.0.0.0', 8080);
  print(
    'o servidor Dart está rodando no link: http://${server.address.host}:${server.port}',
  );
}

