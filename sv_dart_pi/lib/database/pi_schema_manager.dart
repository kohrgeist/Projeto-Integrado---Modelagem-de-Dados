import 'package:mysql_client/mysql_client.dart';
import 'schema_manager.dart';

class MeuSchemaManager implements SchemaManager {
  final MySQLConnection _conn;

  MeuSchemaManager(this._conn);

  @override
  Future<void> criarTabelas() async {
    print('[SchemaManager] Verificando/Criando tabelas (Modelo dbpi2025)...');

    // --- DIMENSÕES (PAIS) ---
    // 1. Operador (Não depende de ninguém)
    await _conn.execute('''
      CREATE TABLE IF NOT EXISTS dbpi2025.operador (
        idoperador INT NOT NULL AUTO_INCREMENT,
        nome VARCHAR(45) NULL,
        idade VARCHAR(45) NULL,
        matriculaEmpresarial VARCHAR(45) NULL,
        PRIMARY KEY (idoperador)
      ) ENGINE = InnoDB
    ''');

    // 2. Maquina (Depende de Operador)
    await _conn.execute('''
      CREATE TABLE IF NOT EXISTS dbpi2025.maquina (
        idmaquina INT NOT NULL AUTO_INCREMENT,
        modelo VARCHAR(45) NULL,
        voltagem INT NULL,
        nome VARCHAR(45) NULL,
        operador_idoperador INT NOT NULL,
        PRIMARY KEY (idmaquina),
        INDEX fk_maquina_operador_idx (operador_idoperador ASC) VISIBLE,
        CONSTRAINT fk_maquina_operador
          FOREIGN KEY (operador_idoperador)
          REFERENCES dbpi2025.operador (idoperador)
      ) ENGINE = InnoDB
    ''');

    // 3. Sensores (Depende de Maquina)
    await _conn.execute('''
      CREATE TABLE IF NOT EXISTS dbpi2025.sensores (
        idsensores INT NOT NULL AUTO_INCREMENT,
        nome VARCHAR(45) NULL,
        modelo VARCHAR(45) NULL,
        maquina_idmaquina INT NOT NULL,
        PRIMARY KEY (idsensores),
        INDEX fk_sensores_maquina1_idx (maquina_idmaquina ASC) VISIBLE,
        CONSTRAINT fk_sensores_maquina1
          FOREIGN KEY (maquina_idmaquina)
          REFERENCES dbpi2025.maquina (idmaquina)
      ) ENGINE = InnoDB
    ''');

    // --- FATO (FILHO) ---
    // 4. Leituras (Depende de Sensores)
    await _conn.execute('''
      CREATE TABLE IF NOT EXISTS dbpi2025.leituras (
        idleituras INT NOT NULL AUTO_INCREMENT,
        valorWatHora DOUBLE NULL,
        unidade VARCHAR(45) NULL, 
        valorTensao DOUBLE NULL,
        data DATETIME NULL,
        valorPotencia DOUBLE NULL,
        valorIrms DOUBLE NULL,
        sensores_idsensores INT NOT NULL,
        PRIMARY KEY (idleituras),
        INDEX fk_leituras_sensores_idx (sensores_idsensores ASC) VISIBLE,
        CONSTRAINT fk_leituras_sensores
          FOREIGN KEY (sensores_idsensores)
          REFERENCES dbpi2025.sensores (idsensores)
      ) ENGINE = InnoDB
    ''');

    print('[SchemaManager] Tabelas OK.');
  }
}
