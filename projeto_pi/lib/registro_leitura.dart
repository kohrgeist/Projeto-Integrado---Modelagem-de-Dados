// Classe que guarda os dados de uma medição (um registro de leitura).
class RegistroLeitura {
// atributos públicos (sem underline agora)
final int idLeitura;
final double valorCorrente;
final double valorPotencia;
final DateTime dataHora;

// construtor: já cria o id baseado no tempo e pega a data/hora atual
RegistroLeitura({
required this.valorCorrente,
required this.valorPotencia,
})  : idLeitura = DateTime.now().millisecondsSinceEpoch, // id único baseado no tempo
dataHora = DateTime.now();

// toString pra imprimir o registro de forma bonitinha
@override
String toString() {
return 'Registro(ID: $idLeitura, Corrente: ${valorCorrente.toStringAsFixed(2)}A, Potência: ${valorPotencia.toStringAsFixed(2)}W, Data: $dataHora)';
}
}