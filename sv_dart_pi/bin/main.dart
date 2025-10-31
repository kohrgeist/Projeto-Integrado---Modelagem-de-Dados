import 'package:sv_dart_pi/services/database_service.dart';
import 'package:sv_dart_pi/services/mysql_service.dart';
import 'package:sv_dart_pi/services/firebase_listener.dart';
import 'package:sv_dart_pi/config.dart';

void main() async {
  // 1 Carregando as configurações
  final settings = mySqlSettings;

  // 2 Criando o serviço de DB
  final DatabaseService dbService = MySqlService(settings);

  // 3 Conectando e preparando o banco
  try {
    await dbService.connect();
    await dbService.inicializarSchema();
  } catch (e) {
    print('[MAIN] Falha fatal ao inicializar o MySQL. Encerrando. $e');
    return;
  }

  // 4 Criaando o ouvinte do Firebase
  final listener = FirebaseListener(
    firebaseDatabaseUrl: firebaseDatabaseUrl,
    firebaseSecret: firebaseDatabaseSecret,
    databaseService: dbService,
  );

  // 5 loop 24h/7 dias
  print('[MAIN] Iniciando serviço de escuta 24 horas...');
  while (true) {
    try {
      await listener.listen();
      print('[MAIN] Conexão do Firebase caiu. Reconectando em 10s...');
      await Future.delayed(const Duration(seconds: 10));
    } catch (e) {
      print('[MAIN] Erro fatal no loop: $e. Reiniciando em 10s...');
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}

// pra encerrar o programa, aperte control + c no terminal. A conexão e o programa cessarão.
// assim, também para o serviço de escuta do firebase e a inserção no mysql.
