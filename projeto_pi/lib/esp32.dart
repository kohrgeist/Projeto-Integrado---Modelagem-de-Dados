import 'sensor_corrente.dart';
import 'registro_leitura.dart';
import 'gerenciador_dados.dart';

// Representa o dispositivo ESP32 que será usado para o projeto
class Esp32 {
  final int _idEsp;
  final String _nome;
  // É final, pq n pode ser trocado após a criação do esp32
  final SensorCorrente _sensorCorrente;

  Esp32({required int idEsp, required String nome})
      : _idEsp = idEsp,
        _nome = nome,
        // O objeto SensorCorrente é instanciado dentro do esp32
        _sensorCorrente = SensorCorrente(
          idSensor: idEsp * 10, // ID do sensor derivado do ID do esp
          nome: 'Sensor de Corrente 1',
          unidade: 'A', // Ampére
        );

  //aqui ele calcula a potência instantânea (em Watts) com base na tensão fornecida
  //ele usa a seguinte fórmula: Potência (W) = Tensão (V) * Corrente (A)
  double calcularPotencia(double tensao) {
    final corrente = _sensorCorrente.lerValor();
    return tensao * corrente;
  }

  // aqui existe uma simulação de processo de iniciar uma leitura completa e enviá-la
  void iniciarLeitura(GerenciadorDados gerenciador, {required double tensao}) {
    print('\nIniciando ciclo de leitura do ESP32 $_nome...');
    _sensorCorrente.exibirInfo();
    enviarDados(gerenciador, tensao: tensao);
  }

  // aqui ele cria um registro e o envia para o gerenciador de dados
  // dependencia da classe esp com a gerenciador
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
