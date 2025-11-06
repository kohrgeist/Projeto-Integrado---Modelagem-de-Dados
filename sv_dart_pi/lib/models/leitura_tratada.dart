class LeituraTratada {
  final double valorWatHora;
  final String unidade;
  final double valorTensao;
  final DateTime data;
  final double valorPotencia;
  final double valorIrms;
  final int sensoresIdsensores;

  LeituraTratada({
    required this.valorWatHora,
    required this.unidade,
    required this.valorTensao,
    required this.data,
    required this.valorPotencia,
    required this.valorIrms,
    required this.sensoresIdsensores,
  });

  factory LeituraTratada.fromFirebaseMap(Map<String, dynamic> data) {
    print('[LeituraTratada] Mapeando dados do Firebase: $data');

    try {
      final double corrente = ((data['corrente'] as num? ?? 0).toDouble() * 100).truncate() / 100;
      final double potencia = ((data['potencia_W'] as num? ?? 0).toDouble() * 100).truncate() / 100;
      final double tensao   = ((data['tensao_V'] as num? ?? 0).toDouble() * 100).truncate() / 100;
      final DateTime dataLeitura = data.containsKey('ultima_leitura')
          ? DateTime.parse(data['ultima_leitura'] as String)
          : DateTime.now();

      final double valorWatHora = 0.0;
      final String unidade = 'W';
      final int idSensor =
          1; // está como valor fixo, visto que, no projeto só temos 1 sensor

      return LeituraTratada(
        valorIrms: corrente,
        valorPotencia: potencia,
        valorTensao: tensao,
        data: dataLeitura,
        valorWatHora: valorWatHora,
        unidade: unidade,
        sensoresIdsensores: idSensor,
      );
    } catch (e) {
      print(
        '[LeituraTratada] ERRO AO MAPEAR DADOS: $e. Dados recebidos: $data',
      );
      rethrow;
    }
  }

  Map<String, dynamic> toMySqlValues() {
    return {
      'valorWatHora': valorWatHora,
      'unidade': unidade,
      'valorTensao': valorTensao,
      'data': data.toIso8601String().substring(0, 19).replaceAll('T', ' '),
      'valorPotencia': valorPotencia,
      'valorIrms': valorIrms,
      'sensores_idsensores': sensoresIdsensores,
    };
  }

  @override
  String toString() {
    return 'LeituraTratada(ID Sensor: $sensoresIdsensores, Potencia: $valorPotencia W)';
  }
}

