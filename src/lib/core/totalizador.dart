import 'totalizador_categoria.dart';
import 'totalizador_estado.dart';

abstract class Totalizador {
  factory Totalizador.porCategoria(List<Map> medicoes) {
    return TotalizadorCategoria(medicoes);
  }

  factory Totalizador.porEstado(List<dynamic> estados, Map ultimaMedicao) {
    return TotalizadorEstado(estados, ultimaMedicao);
  }

  getLinhasTabela();
}
