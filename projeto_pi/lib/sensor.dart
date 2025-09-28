// Estrutura base para um sensor
abstract class Sensor {
  // Atributos para garantir o encapsulamento
  final int _idSensor;
  final String _nome;
  bool _ativo;

  // Método construtor
  Sensor(this._idSensor, this._nome, this._tivo);

  // Requisições públicas para acesso controlado aos atributos privados
  int get idSensor => _idSensor;
  String get nome => _nome;
  bool get isAtivo => _ativo;

  /// Método abstrato para ler o valor do sensor
  double lerValor();

  /// Exibir informações do sensor
  void exibirInfo();
}
