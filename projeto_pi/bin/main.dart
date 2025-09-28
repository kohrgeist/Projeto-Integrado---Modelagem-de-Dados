import '../lib/esp32.dart';
import '../lib/gerenciador_dados.dart';

// Função principal para executar a simulação
void main() async {
  // 1. Instanciação das classes principais
  final gerenciador = GerenciadorDados();
  final meuEsp32 = Esp32(idEsp: 1, nome: 'ESP32 da Sala');
  const double tensaoRede = 220.0;

  // Simulação de leituras em diferentes tempos
  meuEsp32.iniciarLeitura(gerenciador, tensao: tensaoRede);
  await Future.delayed(const Duration(seconds: 1));

  meuEsp32.iniciarLeitura(gerenciador, tensao: tensaoRede);
  await Future.delayed(const Duration(seconds: 1));

  meuEsp32.iniciarLeitura(gerenciador, tensao: tensaoRede);

  // Exibição do histórico de dados coletados
  gerenciador.exibirHistorico();

  // Calcular o consumo de energia em um período
  final agora = DateTime.now();
  final inicioPeriodo = agora.subtract(const Duration(minutes: 1));
  final fimPeriodo = agora.add(const Duration(minutes: 1));

  final consumoTotalKWh = gerenciador.calcularConsumoTotal(
    inicioPeriodo,
    fimPeriodo,
  );

  print('--- CÁLCULO DE CONSUMO ---');
  print(
    'Período de análise: ${inicioPeriodo.toIso8601String()} a ${fimPeriodo.toIso8601String()}',
  );
  print('Consumo total no período: ${consumoTotalKWh.toStringAsFixed(4)} kWh');
  print('--------------------------');
}
