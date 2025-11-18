class Maquina {
  String nome;
  String modelo;
  int voltagem;
  int operadorId;

  Maquina({
    required this.nome,
    required this.modelo,
    required this.voltagem,
    required this.operadorId,
  });

  @override
  String toString() {
    return 'Maquina(Nome: $nome, Modelo: $modelo, Voltagem: ${voltagem}V)';
  }
}
