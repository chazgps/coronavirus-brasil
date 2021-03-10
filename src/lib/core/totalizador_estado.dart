import 'package:corona/core/totalizador.dart';

class TotalizadorEstado implements Totalizador {
  Map ultimaMedicao;
  List<dynamic> estados;

  TotalizadorEstado(this.estados, this.ultimaMedicao);

  List<List<String>> getLinhasTabela() {
    List<List<String>> linhas = [];
    int qtdeTotalSuspeitos = 0;
    int qtdeTotalConfirmados = 0;
    int qtdeTotalDescartados = 0;
    int qtdeTotalMortes = 0;

    // Percorra todos os estados
    for (int i = 0; i < ultimaMedicao['values'].length; i++) {
      var medicao = ultimaMedicao['values'][i];

      final int qtdeSuspeitos =
          (medicao.containsKey('suspects') ? medicao['suspects'] : 0);
      qtdeTotalSuspeitos += qtdeSuspeitos;

      final int qtdeConfirmados =
          (medicao.containsKey('cases') ? medicao['cases'] : 0);
      qtdeTotalConfirmados += qtdeConfirmados;

      final int qtdeDescartados =
          (medicao.containsKey('refuses') ? medicao['refuses'] : 0);
      qtdeTotalDescartados += qtdeDescartados;

      final int qtdeMortes =
          (medicao.containsKey('deaths') ? medicao['deaths'] : 0);
      qtdeTotalMortes += qtdeMortes;

      List<String> colunas = [];
      colunas.add(_getEstado(medicao['uid']));
      colunas.add(qtdeSuspeitos.toString());
      colunas.add(qtdeConfirmados.toString());
      colunas.add(qtdeDescartados.toString());
      colunas.add(qtdeMortes.toString());

      linhas.add(colunas);
    }

    linhas.add(['Total',
      qtdeTotalSuspeitos.toString(),
      qtdeTotalConfirmados.toString(),
      qtdeTotalDescartados.toString(),
      qtdeTotalMortes.toString()
    ]);

    return linhas;
  }

  String _getEstado(uid) {
    String estado = '?';

    for (int i = 0; i < estados.length; i++) {
      if (estados[i]['id'] == uid) {
        estado = estados[i]['nome'];
        break;
      }
    }

    return estado;
  }
}
