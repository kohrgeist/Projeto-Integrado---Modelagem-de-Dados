/// Classe abstrata que define a estrutura base para um sensor.
/// Utilizada para garantir que todos os sensores concretos implementem
/// os métodos essenciais, aplicando o princípio do Polimorfismo.
abstract class Sensor {
  // Atributos privados para garantir o encapsulamento.
  final int _idSensor;
  final String _nome;
  bool _ativo;

  // Construtor da classe base.
  Sensor(this._idSensor, this._nome, this._ativo);

  // Getters públicos para acesso controlado aos atributos privados.
  int get idSensor => _idSensor;
  String get nome => _nome;
  bool get isAtivo => _ativo;

  /// Método abstrato para ler o valor do sensor.
  /// A implementação será específica para cada tipo de sensor.
  double lerValor();

  /// Método abstrato para exibir informações do sensor.
  void exibirInfo();
}
