import '../models/registro_leitura.dart';

/// Gerencia a lógica de negócio relacionada ao histórico de leituras.
/// Separa a lógica da manipulação de dados dos modelos de dados.
class GerenciadorDados {
  // A lista de registros é privada, expondo-a de forma controlada (encapsulamento).
  final List<RegistroLeitura> _historico = [];

  /// Retorna uma cópia da lista de histórico para evitar modificações externas.
  List<RegistroLeitura> get historico => List.unmodifiable(_historico);

  /// Adiciona uma nova leitura ao histórico.
  void adicionarLeitura(RegistroLeitura leitura) {
    _historico.add(leitura);
    print('Novo registro adicionado ao histórico: $leitura');
  }

  /// Exibe todos os registros do histórico no console.
  void exibirHistorico() {
    print('\n--- Histórico de Leituras ---');
    if (_historico.isEmpty) {
      print('Nenhum registro encontrado.');
    } else {
      _historico.forEach(print);
    }
    print('---------------------------\n');
  }

  /// Calcula o consumo total de energia (em kWh) em um determinado período.
  /// Simulação: assume que cada registro representa o consumo médio por uma hora.
  double calcularConsumoTotal(DateTime dataInicial, DateTime dataFinal) {
    double somaPotenciaWatts = 0.0;

    // Filtra os registros que estão dentro do intervalo de datas.
    final registrosNoPeriodo = _historico.where((r) =>
        r.dataHora.isAfter(dataInicial) && r.dataHora.isBefore(dataFinal));

    for (var registro in registrosNoPeriodo) {
      somaPotenciaWatts += registro.valorPotencia;
    }

    // Convertendo a potência para Quilowatts-hora (kWh).
    // Supondo que cada leitura representa 1 hora de consumo.
    double consumoKWh = (somaPotenciaWatts / 1000);
    return consumoKWh;
  }
}
