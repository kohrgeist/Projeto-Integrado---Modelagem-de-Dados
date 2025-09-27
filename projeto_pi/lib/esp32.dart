import 'sensor_corrente.dart';
import 'registro_leitura.dart';
import '../services/gerenciador_dados.dart';

/// Representa o dispositivo ESP32, que contém um sensor de corrente (Composição).
class Esp32 {
  final int _idEsp;
  final String _nome;
  // O sensor é parte integrante do ESP32 (Composição).
  // É final, pois não pode ser trocado após a criação do ESP32.
  final SensorCorrente _sensorCorrente;

  Esp32({required int idEsp, required String nome})
      : _idEsp = idEsp,
        _nome = nome,
        // O objeto SensorCorrente é instanciado DENTRO do construtor do Esp32.
        _sensorCorrente = SensorCorrente(
          idSensor: idEsp * 10, // ID do sensor derivado do ID do ESP
          nome: 'Sensor de Corrente Interno',
          unidade: 'A', // Ampere
        );

  /// Calcula a potência instantânea (em Watts) com base na tensão fornecida.
  /// Potência (W) = Tensão (V) * Corrente (A)
  double calcularPotencia(double tensao) {
    final corrente = _sensorCorrente.lerValor();
    return tensao * corrente;
  }

  /// Simula o processo de iniciar uma leitura completa e enviá-la.
  void iniciarLeitura(GerenciadorDados gerenciador, {required double tensao}) {
    print('\nIniciando ciclo de leitura do ESP32 $_nome...');
    _sensorCorrente.exibirInfo();
    enviarDados(gerenciador, tensao: tensao);
  }

  /// Cria um registro e o envia para o gerenciador de dados.
  /// Demonstra a dependência da classe Esp32 com o GerenciadorDados.
  void enviarDados(GerenciadorDados gerenciador, {required double tensao}) {
    final potencia = calcularPotencia(tensao);
    
    final novoRegistro = RegistroLeitura(
      valorCorrente: _sensorCorrente.lerValor(),
      valorPotencia: potencia,
    );
    
    gerenciador.adicionarLeitura(novoRegistro);
    print('Dados enviados com sucesso pelo ESP32 $_nome.');
  }
}
