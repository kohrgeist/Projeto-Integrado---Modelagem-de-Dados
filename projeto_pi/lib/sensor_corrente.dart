import 'dart:math';
import 'sensor.dart';

/// Representa um sensor de corrente específico.
/// Herda da classe abstrata [Sensor] e implementa seus métodos.
class SensorCorrente extends Sensor {
  // Atributos específicos do sensor de corrente.
  double _valor;
  final String _unidade;

  // Construtor que inicializa os atributos da classe filha e da classe pai (super).
  SensorCorrente({
    required int idSensor,
    required String nome,
    required String unidade,
    bool ativo = true,
  })  : _valor = 0.0, // Valor inicial
        _unidade = unidade,
        super(idSensor, nome, ativo);

  /// Sobrescreve o método [lerValor] para simular a leitura de corrente.
  /// Em um cenário real, aqui ocorreria a comunicação com o hardware.
  @override
  double lerValor() {
    // Simula uma leitura de corrente com uma pequena variação aleatória.
    _valor = 5.0 + Random().nextDouble() * 1.5; // Ex: valor base de 5A +/- 1.5A
    print('Lendo sensor de corrente... Valor: ${_valor.toStringAsFixed(2)}A');
    return _valor;
  }

  /// Sobrescreve o método [exibirInfo] para mostrar os dados do sensor.
  @override
  void exibirInfo() {
    print('--- Informações do Sensor ---');
    print('ID: $idSensor');
    print('Nome: $nome');
    print('Tipo: Sensor de Corrente');
    print('Unidade: $_unidade');
    print('Status: ${isAtivo ? 'Ativo' : 'Inativo'}');
    print('-----------------------------');
  }
}
