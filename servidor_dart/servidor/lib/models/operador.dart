class Operador {
  String nome;
  String idade;
  String matriculaEmpresarial;

  Operador({
    required this.nome,
    required this.idade,
    required this.matriculaEmpresarial,
  });

  @override
  String toString() {
    return 'Operador(Nome: $nome, Idade: $idade, Matrícula: $matriculaEmpresarial)';
  }
}
