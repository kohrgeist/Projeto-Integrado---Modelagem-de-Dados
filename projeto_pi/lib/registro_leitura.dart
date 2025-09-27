/// Classe de modelo que encapsula os dados de uma medição.
class RegistroLeitura {
  // Atributos privados
  final int _idLeitura;
  final double _valorCorrente;
  final double _valorPotencia;
  final DateTime _dataHora;

  // Construtor com inicialização automática do ID (simulado) e data/hora.
  RegistroLeitura({
    required double valorCorrente,
    required double valorPotencia,
  })  : _idLeitura = DateTime.now().millisecondsSinceEpoch, // ID único baseado no tempo
        _valorCorrente = valorCorrente,
        _valorPotencia = valorPotencia,
        _dataHora = DateTime.now();

  // Getters para acesso aos dados
  int get idLeitura => _idLeitura;
  double get valorCorrente => _valorCorrente;
  double get valorPotencia => _valorPotencia;
  DateTime get dataHora => _dataHora;

  @override
  String toString() {
    return 'Registro(ID: $_idLeitura, Corrente: ${_valorCorrente.toStringAsFixed(2)}A, Potência: ${_valorPotencia.toStringAsFixed(2)}W, Data: $_dataHora)';
  }
}
