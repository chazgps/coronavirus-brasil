import 'package:flutter/material.dart';
import 'package:corona/core/debug.dart' as Debug;
import 'package:corona/core/fonts.dart' as Fonts;
import 'package:corona/core/cores.dart' as Cores;
import 'package:corona/core/system.dart' as System;
import 'package:cloud_firestore/cloud_firestore.dart';

class NoticiasPage extends StatefulWidget {
  final List<List<String>> sites = [
    ['0', 'Ministério da Saúde'],
    ['1', 'Ministério da Saúde'],
    ['2', 'Blog da Saúde'],
    ['3', 'Prefeitura de São Paulo - Últimas notícias'],
    ['4', 'Secretaria de Saúde do Ceará'],
    ['5', 'Secretaria de Saúde do Distrito Federal'],
    ['6', 'Secretaria de Saúde de Minas Gerais'],
    ['7', 'Secretaria de Saúde do Mato Grosso do Sul'],
    ['8', 'Secretaria de Saúde do Pará'],
    ['9', 'Secretaria de Saúde do Rio Grande do Sul'],
    ['10', 'Secretaria de Saúde do Sergipe']
  ];

  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

/**
 * O mixim AutomaticKeepAliveClientMixin é o que permite que este objeto NoticiasPageState não seja
 * destruído a cada vez que um Tab é selecionado.
 */
class _NoticiasPageState extends State<NoticiasPage>
    with AutomaticKeepAliveClientMixin<NoticiasPage> {
  // Implementação do mixin AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Stream<QuerySnapshot> meuStream = Firestore.instance
        .collection('Noticia')
        .orderBy('dh_pub', descending: true)
        .limit(30)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: meuStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _getWidgetErro(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _getWidgetProgresso();
        } else {
          return _getWidgetSucesso(snapshot.data);
        }
      },
    );
  }

  _getWidgetErro(mensagemErro) {
    String mensagem = 'Não foi possível obter as notícias.\n\n' +
        'Verifique se sua rede de dados está ativa e funcionando.\n\n' +
        'As notícias aparecerão aqui assim que este aplicativo conseguir acessar a Internet.';

    if (Debug.DEBUGGING) {
      mensagem += '\n$mensagemErro';
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 30, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          SizedBox(height: 15),
          Text(mensagem,
              textAlign: TextAlign.center, style: Fonts.estiloPadrao),
        ],
      ),
    );
  }

  _getWidgetProgresso() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text('Buscando notícias sobre o Coronavírus...',
                  style: Fonts.estiloPadrao, textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }

  // Unicamente chamado pelo FutureBuilder
  Widget _getWidgetSucesso(QuerySnapshot query) {
    List<DocumentSnapshot> documentos =
        query.documents.map((DocumentSnapshot document) {
      return document;
    }).toList();

    if (documentos.length == 0) {
      return _getWidgetErro('Não existem notícias para exibir.');
    }

    return Container(
      color: Cores.corFundoPagina,
      child: ListView.builder(
        addSemanticIndexes: true,
        semanticChildCount: documentos.length,
        padding: EdgeInsets.only(bottom: 10),
        itemCount: documentos.length,
        itemBuilder: (context, index) {
          final String id_site = documentos[index]['id_site'];
          dynamic site = widget.sites
              .firstWhere((site) => site[0] == id_site, orElse: () => null);
          site = site[1];

          final Timestamp horario = documentos[index]['dh_pub'];
          final String dhNoticiaStr =
              System.getDataDeDateTime(horario.toDate());

          return Semantics(
            label: (index < documentos.length - 1
                ? 'notícia ' + (index + 1).toString()
                : 'última notícia'),
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Color(0xFFfedf00),
                  onTap: () {
                    _abrirNoticia(documentos[index]);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(site, style: Fonts.estiloNoticiaSite),
                        Text('${documentos[index]['titulo']}',
                            style: Fonts.estiloNoticiaTitulo),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(dhNoticiaStr,
                              style: Fonts.estiloNoticiaData),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _abrirNoticia(DocumentSnapshot documento) {
    //if (documento['descricao'] == '') {
    System.launchURL(documento['link']);
    //return;
    //}

    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisualizaNoticiaPage(noticia),
      ),
    );*/
  }
}
