class Sensor {
  String nome;
  String descricao;
  bool estado;
  int maquinaId;

  Sensor({
    required this.nome,
    required this.descricao,
    required this.estado,
    required this.maquinaId,
  });

  @override
  String toString() {
    return 'Sensor(Nome: $nome, Estado: ${estado ? "Ativo" : "Inativo"})';
  }
}
