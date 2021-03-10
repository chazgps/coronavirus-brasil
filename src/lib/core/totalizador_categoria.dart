import 'package:corona/core/totalizador.dart';

class TotalizadorCategoria implements Totalizador {
  List<Map> medicoes;

  TotalizadorCategoria(this.medicoes);

  List<List<String>> getLinhasTabela() {
    List<List<String>> linhas = [];

    List<String> linha = ['Suspeitos', ..._getLinha(medicoes, 'suspects')];
    linhas.add(linha);

    linha = ['Confirmados', ..._getLinha(medicoes, 'cases')];
    linhas.add(linha);

    linha = ['Descartados', ..._getLinha(medicoes, 'refuses')];
    linhas.add(linha);

    linha = ['Mortes', ..._getLinha(medicoes, 'deaths')];
    linhas.add(linha);

    return linhas;
  }

  List<String> _getLinha(List<Map> medicoes, item) {
    List<String> valoresResultantes = [];

    for (int i = 0; i < medicoes.length; i++) {
      Map medicao = medicoes[i];
      int valorAcumulado = 0;

      // Percorra todos os estados desta medicao
      for (int j = 0; j< medicao['values'].length; j++) {

        Map ultimaMedicaoEstado = medicao['values'][j];

        if (ultimaMedicaoEstado.containsKey(item)) {
          valorAcumulado += ultimaMedicaoEstado[item];
        }
      }

      valoresResultantes.add(valorAcumulado.toString());
    }

    return valoresResultantes;
  }
}
