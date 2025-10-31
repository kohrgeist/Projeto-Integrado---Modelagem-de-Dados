import 'package:mysql_client/mysql_client.dart';
import '../../database/schema_manager.dart';
import '../database/pi_schema_manager.dart';
import '../../models/leitura_tratada.dart';
import '../../config.dart';
import 'database_service.dart';

class MySqlService implements DatabaseService {
  final ConnectionSettings settings;
  late MySQLConnection _conn;
  late SchemaManager _schemaManager;

  MySqlService(this.settings);

  @override
  Future<void> connect() async {
    print('[MySQL] Conectando ao banco de dados...');
    try {
      var tempConn = await MySQLConnection.createConnection(
        host: settings.host,
        port: settings.port,
        userName: settings.user,
        password: settings.password ?? '',
      );
      await tempConn.connect();
      await tempConn.execute('CREATE DATABASE IF NOT EXISTS ${settings.db}');
      await tempConn.close();

      _conn = await MySQLConnection.createConnection(
        host: settings.host,
        port: settings.port,
        userName: settings.user,
        password: settings.password ?? '',
        databaseName: settings.db ?? '',
      );
      await _conn.connect();
      print('[MySQL] Conexão estabelecida com ${settings.db}');
      _schemaManager = MeuSchemaManager(_conn);
    } catch (e) {
      print("[MySQL] ERRO ao conectar no MySQL: $e");
      rethrow;
    }
  }

  @override
  Future<void> inicializarSchema() {
    return _schemaManager.criarTabelas();
  }

  @override
  Future<void> salvarLeitura(LeituraTratada leitura) async {
    print('[MySQL] Salvando nova leitura: $leitura \n');
    try {
      final values = leitura.toMySqlValues();
      await _conn.execute('''
        INSERT INTO leituras (valorWatHora, unidade, valorTensao, data, valorPotencia, valorIrms, sensores_idsensores)
        VALUES (:valorWatHora, :unidade, :valorTensao, :data, :valorPotencia, :valorIrms, :sensores_idsensores)
        ''', values);
    } catch (e) {
      print('[MySQL] ERRO ao salvar leitura: $e');
    }
  }

  @override
  Future<void> close() async {
    await _conn.close();
  }
}
