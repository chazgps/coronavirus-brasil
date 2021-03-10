library card;

import 'package:flutter/material.dart';
import 'package:corona/core/fonts.dart' as Fonts;
import 'package:corona/core/cores.dart' as Cores;

Widget getPage(List<Widget> conteudo) {
  return Container(
    color: Cores.corFundoPagina,
    child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: conteudo),
        ),
      ],
    ),
  );
}

getCard(String titulo, String mensagem, dynamic conteudo) {
  List<Widget> widgets = [];

  if (mensagem != null) {
    widgets.add(_getTextoCorpo(mensagem));
  }

  if (conteudo != null) {
    if (conteudo is List) {
      widgets.add(_getImagemComTexto(conteudo as List<List<String>>));
    } else {
      widgets.add(conteudo);
    }
  }

  return Card(
    margin: EdgeInsets.only(bottom: 15),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      children: [
        _getTitulo(titulo),
        ...widgets,
      ],
    ),
  );
}

Widget _getTitulo(String texto) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    padding: EdgeInsets.all(20),
    child: Text(texto, style: Fonts.estiloFaqCardTitulo),
  );
}

Widget _getTextoCorpo(String texto) {
  return Padding(
    padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
    child: Text(texto, style: Fonts.estiloFaqCardCorpo),
  );
}

Widget _getImagemComTexto(List<List<String>> linhas) {
  List<Widget> widgets = [];

  for (int i = 0; i < linhas.length; i++) {
    List<String> linha = linhas[i];

    Widget imagem = ExcludeSemantics(
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Image.asset('assets/images/' + linha[0] + '.png'),
      ),
    );

    Widget texto = Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Text(linha[1], style: Fonts.estiloFaqCardImagem),
      ),
    );

    Row row = Row(children: [imagem, texto]);
    widgets.add(row);

    if (i < linhas.length - 1) {
      widgets.add(Divider(
        color: Colors.grey,
        indent: 30,
        endIndent: 30,
      ));
    }
  }

  Widget coluna = Padding(
    padding: EdgeInsets.only(top: 10, bottom: 10),
    child: Column(children: widgets),
  );

  return coluna;
}
