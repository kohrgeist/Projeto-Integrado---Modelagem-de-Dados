import 'dart:io';
import 'package:sv_dart_pi/services/database_service.dart';
import 'package:sv_dart_pi/services/mysql_service.dart';
import 'package:sv_dart_pi/services/firebase_service.dart';
import 'package:sv_dart_pi/config.dart';
import 'package:sv_dart_pi/models/operador.dart';
import 'package:sv_dart_pi/models/maquina.dart';
import 'package:sv_dart_pi/models/sensor.dart';

void main() async {
  print('=== Sistema de Monitoramento de Energia ===\n');

  // Inicializa o banco de dados
  final DatabaseService dbService = MySqlService(mySqlSettings);

  try {
    await dbService.connect();
    await dbService.inicializarSchema();
    print('[OK] Sistema inicializado com sucesso!\n');
  } catch (e) {
    print('[ERRO] Falha ao inicializar: $e');
    return;
  }

  // Inicializa o serviço Firebase
  final firebaseService = FirebaseService(
    firebaseDatabaseUrl: firebaseDatabaseUrl,
    firebaseSecret: firebaseDatabaseSecret,
    databaseService: dbService,
  );

  // Loop do menu principal
  bool executando = true;
  while (executando) {
    executando = await exibirMenu(dbService, firebaseService);
  }

  await dbService.close();
  print('\n[Sistema Encerrado]');
}

Future<bool> exibirMenu(DatabaseService db, FirebaseService firebase) async {
  print('\n-------------------------------------------');
  print('|        MENU DE CONFIGURAÇÃO               |');
  print('|-------------------------------------------|');
  print('| 1. Inserir Novo Operário                  |');
  print('| 2. Inserir Nova Máquina                   |');
  print('| 3. Inserir Novo Sensor                    |');
  print('| 4. Atualizar Leituras (Timer)             |');
  print('| 5. Sair                                   |');
  print('---------------------------------------------');
  stdout.write('\nEscolha uma opção: ');

  final opcao = stdin.readLineSync() ?? '';

  switch (opcao) {
    case '1':
      await inserirOperador(db);
      break;
    case '2':
      await inserirMaquina(db);
      break;
    case '3':
      await inserirSensor(db);
      break;
    case '4':
      await iniciarMonitoramento(firebase);
      break;
    case '5':
      return false;
    default:
      print('\n[ERRO] Opção inválida!');
  }

  return true;
}

Future<void> inserirOperador(DatabaseService db) async {
  print('\n--- Cadastro de Operário ---');

  stdout.write('Nome: ');
  final nome = stdin.readLineSync() ?? '';

  stdout.write('Idade: ');
  final idade = stdin.readLineSync() ?? '';

  stdout.write('Matrícula Empresarial: ');
  final matricula = stdin.readLineSync() ?? '';

  final operador = Operador(
    nome: nome,
    idade: idade,
    matriculaEmpresarial: matricula,
  );

  try {
    await db.inserirOperador(operador);
    print('[OK] Operário cadastrado com sucesso!');
  } catch (e) {
    print('[ERRO] Falha ao cadastrar operário: $e');
  }
}

Future<void> inserirMaquina(DatabaseService db) async {
  print('\n--- Cadastro de Máquina ---');

  stdout.write('Nome da Máquina: ');
  final nome = stdin.readLineSync() ?? '';

  stdout.write('Modelo: ');
  final modelo = stdin.readLineSync() ?? '';

  stdout.write('Voltagem (V): ');
  final voltagem = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

  stdout.write('ID do Operador Responsável: ');
  final idOperador = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

  final maquina = Maquina(
    nome: nome,
    modelo: modelo,
    voltagem: voltagem,
    operadorId: idOperador,
  );

  try {
    await db.inserirMaquina(maquina);
    print('[OK] Máquina cadastrada com sucesso!');
  } catch (e) {
    print('[ERRO] Falha ao cadastrar máquina: $e');
  }
}

Future<void> inserirSensor(DatabaseService db) async {
  print('\n--- Cadastro de Sensor ---');

  stdout.write('Nome do Sensor: ');
  final nome = stdin.readLineSync() ?? '';

  stdout.write('Descrição: ');
  final descricao = stdin.readLineSync() ?? '';

  stdout.write('Estado (ativo/inativo): ');
  final estado = (stdin.readLineSync() ?? '').toLowerCase() == 'ativo';

  stdout.write('ID da Máquina: ');
  final idMaquina = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

  final sensor = Sensor(
    nome: nome,
    descricao: descricao,
    estado: estado,
    maquinaId: idMaquina,
  );

  try {
    await db.inserirSensor(sensor);
    print('[OK] Sensor cadastrado com sucesso!');
  } catch (e) {
    print('[ERRO] Falha ao cadastrar sensor: $e');
  }
}

Future<void> iniciarMonitoramento(FirebaseService firebase) async {
  print('\n-----------------------------------------');
  print('|   MONITORAMENTO DE LEITURAS ATIVO      |');
  print('|----------------------------------------|');
  print('| O sistema buscará dados a cada 12s     |');
  print('| Digite Control+C no menu para PARAR    |');
  print('|----------------------------------------|\n');

  bool monitorando = true;
  int contador = 0;
  //loop
  while (monitorando) {
    try {
      contador++;
      final agora = DateTime.now();
      print(
        '\n[$contador] ${agora.hour}:${agora.minute}:${agora.second} - Checando Firebase...',
      );

      await firebase.buscarEInserirLeitura();

      print('[TIMER] Próxima leitura em 12 segundos...');
      print('[INFO] Digite Control+C no menu para parar o monitoramento\n');

      // Espera 12 segundos
      await Future.delayed(const Duration(seconds: 12));
    } catch (e) {
      print('[ERRO] Falha ao buscar dados: $e');
      print('[TIMER] Tentando novamente em 12 segundos...\n');
      await Future.delayed(const Duration(seconds: 12));
    }
  }
}
