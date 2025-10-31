import '../models/leitura_tratada.dart';

abstract class DatabaseService {
  Future<void> connect();
  Future<void> inicializarSchema();
  Future<void> salvarLeitura(LeituraTratada leitura);
  Future<void> close();
}
