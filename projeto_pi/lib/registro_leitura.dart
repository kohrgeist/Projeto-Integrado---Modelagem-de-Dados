// Classe que guarda os dados de uma medição (tipo um registro de leitura).
class RegistroLeitura {
// atributos privados pra segurar as infos
final int _idLeitura;
final double _valorCorrente;
final double _valorPotencia;
final DateTime _dataHora;

// construtor: já cria o id baseado no tempo e pega a data/hora atual
RegistroLeitura({
required double valorCorrente,
required double valorPotencia,
}) : _idLeitura = DateTime.now().millisecondsSinceEpoch, // id único "fake" só pelo tempo
_valorCorrente = valorCorrente,
_valorPotencia = valorPotencia,
_dataHora = DateTime.now();

// getters pra acessar os dados (já que os atributos tão privados)
int get idLeitura => _idLeitura;
double get valorCorrente => _valorCorrente;
double get valorPotencia => _valorPotencia;
DateTime get dataHora => _dataHora;

// toString pra imprimir o registro de forma bonitinha
@override
String toString() {
return 'Registro(ID: $_idLeitura, Corrente: ${_valorCorrente.toStringAsFixed(2)}A, Potência: ${_valorPotencia.toStringAsFixed(2)}W, Data: $_dataHora)';
}
}