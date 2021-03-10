import 'package:corona/widgets/data_table.dart';
import 'package:flutter/material.dart'
    hide DataTable, DataColumn, DataRow, DataCell;

class TabelaDadosWidget extends StatefulWidget {
  List<String> tituloColunas;
  List<List<String>> valoresLinhas;
  TextStyle estiloTextoPrimeiraColuna;
  TextStyle estiloTextoDemaisColunas;
  String semanticsLabel;

  TabelaDadosWidget(
      {this.tituloColunas,
      this.valoresLinhas,
      this.estiloTextoPrimeiraColuna,
      this.estiloTextoDemaisColunas,
      this.semanticsLabel});

  @override
  _TabelaDadosWidgetState createState() => _TabelaDadosWidgetState();
}

class _TabelaDadosWidgetState extends State<TabelaDadosWidget> {
  @override
  Widget build(BuildContext context) {
    // Gerando as DataColumns
    List<DataColumn> colunas = [];
    var valorColuna;

    for (int i = 0; i < widget.tituloColunas.length; i++) {
      if (i == 0) {
        valorColuna = '';
      } else {
        valorColuna = widget.tituloColunas[i];
      }

      Widget coluna =
          Text(valorColuna, style: widget.estiloTextoPrimeiraColuna);

      // A 1a coluna como é vazia, precisamos escondê-la para
      // que leitor de tela não tente interpretá-la e com isto
      // estrague a experiência do usuário
      if (i == 0) {
        coluna = Semantics(child: coluna, hidden: true, enabled: false);
      }

      DataColumn dataColuna = DataColumn(label: coluna);
      colunas.add(dataColuna);
    }

    // Gerando as DataRows
    List<DataRow> linhas = [];

    for (int i = 0; i < widget.valoresLinhas.length; i++) {
      List<String> linha = widget.valoresLinhas[i];

      List<DataCell> celulas = [];

      for (int j = 0; j < linha.length; j++) {
        String valorLinha = linha[j];

        TextStyle estilo = (j == 0
            ? widget.estiloTextoPrimeiraColuna
            : widget.estiloTextoDemaisColunas);

        Widget valorCelula = Text(valorLinha, style: estilo);
        DataCell celula = DataCell(valorCelula);
        celulas.add(celula);
      }

      linhas.add(DataRow(cells: celulas));
    }

    return Semantics(
      label: widget.semanticsLabel,
      excludeSemantics: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Semantics(
          child: DataTable(columns: colunas, rows: linhas, columnSpacing: 0),
        ),
      ),
    );
  }
}
