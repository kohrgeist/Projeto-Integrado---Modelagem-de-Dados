import '../models/leitura_tratada.dart';
import '../models/operador.dart';
import '../models/maquina.dart';
import '../models/sensor.dart';

/// Interface abstrata para operações de banco de dados
/// Implementa o conceito de POO: Abstração
abstract class DatabaseService {
  Future<void> connect();
  Future<void> inicializarSchema();

  // CRUD de Leituras
  Future<void> salvarLeitura(LeituraTratada leitura);

  // CRUD de Operadores
  Future<void> inserirOperador(Operador operador);

  // CRUD de Máquinas
  Future<void> inserirMaquina(Maquina maquina);

  // CRUD de Sensores
  Future<void> inserirSensor(Sensor sensor);

  Future<void> close();
}
