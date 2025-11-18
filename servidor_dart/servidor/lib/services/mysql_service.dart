import 'package:mysql_client/mysql_client.dart';
import '../database/schema_manager.dart';
import '../database/schema_pi.dart';
import '../models/leitura_tratada.dart';
import '../models/operador.dart';
import '../models/maquina.dart';
import '../models/sensor.dart';
import '../config.dart';
import 'database_service.dart';

/// Implementação concreta do DatabaseService para MySQL
/// Conceitos POO: Herança (implements), Encapsulamento, Polimorfismo
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
      print("[MySQL] ERRO ao conectar: $e");
      rethrow;
    }
  }

  @override
  Future<void> inicializarSchema() {
    return _schemaManager.criarTabelas();
  }

  @override
  Future<void> salvarLeitura(LeituraTratada leitura) async {
    print('[MySQL] Salvando leitura: $leitura');
    try {
      final values = leitura.toMySqlValues();
      await _conn.execute('''
        INSERT INTO leituras (valorWatHora, unidade, valorTensao, data, valorPotencia, valorIrms, sensores_idsensores)
        VALUES (:valorWatHora, :unidade, :valorTensao, :data, :valorPotencia, :valorIrms, :sensores_idsensores)
      ''', values);
    } catch (e) {
      print('[MySQL] ERRO ao salvar leitura: $e');
      rethrow;
    }
  }

  @override
  Future<void> inserirOperador(Operador operador) async {
    print('[MySQL] Inserindo operador: ${operador.nome}');
    try {
      await _conn.execute(
        '''
        INSERT INTO operador (nome, idade, matriculaEmpresarial)
        VALUES (:nome, :idade, :matricula)
      ''',
        {
          'nome': operador.nome,
          'idade': operador.idade,
          'matricula': operador.matriculaEmpresarial,
        },
      );
    } catch (e) {
      print('[MySQL] ERRO ao inserir operador: $e');
      rethrow;
    }
  }

  @override
  Future<void> inserirMaquina(Maquina maquina) async {
    print('[MySQL] Inserindo máquina: ${maquina.nome}');
    try {
      await _conn.execute(
        '''
        INSERT INTO maquina (nome, modelo, voltagem, operador_idoperador)
        VALUES (:nome, :modelo, :voltagem, :operador_id)
      ''',
        {
          'nome': maquina.nome,
          'modelo': maquina.modelo,
          'voltagem': maquina.voltagem,
          'operador_id': maquina.operadorId,
        },
      );
    } catch (e) {
      print('[MySQL] ERRO ao inserir máquina: $e');
      rethrow;
    }
  }

  @override
  Future<void> inserirSensor(Sensor sensor) async {
    print('[MySQL] Inserindo sensor: ${sensor.nome}');
    try {
      await _conn.execute(
        '''
        INSERT INTO sensores (nome, descricao, estado, maquina_idmaquina)
        VALUES (:nome, :descricao, :estado, :maquina_id)
      ''',
        {
          'nome': sensor.nome,
          'descricao': sensor.descricao,
          'estado': sensor.estado ? 1 : 0,
          'maquina_id': sensor.maquinaId,
        },
      );
    } catch (e) {
      print('[MySQL] ERRO ao inserir sensor: $e');
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await _conn.close();
    print('[MySQL] Conexão encerrada.');
  }
}
