import 'dart:math';
import 'sensor.dart';


// herdando os atributos da classe Sensor para a classe nova
class SensorCorrente extends Sensor {
  double _valor;
  final String _unidade;

  // utilizando o método construtor para usar os atributos herdados do Sensor
  SensorCorrente({
    required int idSensor,
    required String nome,
    required String unidade,
    bool ativo = true,
  })  : _valor = 0.0, 
        _unidade = unidade,
        super(idSensor, nome, ativo);

  @override
  double lerValor() {
    //uma leitura simulada
    _valor = 5.0 + Random().nextDouble() * 1.5; 
    print("Corrente atual... ${_valor.toStringAsFixed(2)}");
    return _valor;
  }

  // mostrando o status do código
  @override
  void exibirInfo() {
    print("Informações do Sensor...");
    print("ID do Sensor: $idSensor");
    print("Nome: $nome");
    print("Unidade: $_unidade");
    print("Status: ${isAtivo ? "O sensor $nome está ativo." : "O sensor $nome está inativo."}");
  }
}
