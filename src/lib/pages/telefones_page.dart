import 'package:flutter/material.dart';
import 'package:corona/core/fonts.dart' as Fonts;
import 'package:corona/core/cores.dart' as Cores;
import 'package:corona/core/system.dart' as System;

class TelefenosPage extends StatelessWidget {
  List<List<String>> telefones = [
    [
      'Ministério da Saúde',
      'Você poderá tirar dúvidas sobre o coronavírus através da opção 1 do menu de voz.',
      '136'
    ],
    [
      'Campinas - SP',
      'A prefeitura de Campinas dedicou a partir de 16 de março de 2020 um número exclusivo para ' +
          'atender as pessoas sobre o coronavírus.',
      '160'
    ],
    [
      'Curitiba - PR',
      'A Secretaria Municipal da Saúde colocou em operação nesta sexta-feira (13/3) ' +
          'um novo telefone de contato para esclarecer dúvidas dos moradores de Curitiba a respeito do coronavírus.',
      '(41) 3350-9000'
    ],
    [
      'João Pessoa - PB',
      'Prefeitura disponibiliza telefone da Central de Orientação para Prevenção ao Coronavírus com médicos e enfermeiros para esclarecimentos à população',
      '(83) 3218-9214'
    ],
    [
      'Ponta Grossa - PR',
      'Prefeitura lança canal de comunicação para tirar dúvidas e passar orientações sobre a doença.',
      '(42) 3220-1019'
    ],
    [
      'Estado do Rio Grande do Sul',
      'A população e os profissionais de saúde do RS podem entrar em contato para '+
  'esclarecimento de dúvidas e notificações.',
      '150'
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      color: Cores.corFundoPagina,
      child: ListView.builder(
        addSemanticIndexes: true,
        semanticChildCount: telefones.length,
        padding: EdgeInsets.only(bottom: 10),
        itemCount: telefones.length,
        itemBuilder: (BuildContext context, int index) {
          List<String> telefone = telefones[index];

          return Card(
            margin: EdgeInsets.only(top: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Semantics(
                    label: (index < telefones.length - 1
                        ? 'telefone ' + (index + 1).toString()
                        : 'última telefone'),
                    child: ListTile(
                      title:
                          Text(telefone[0], style: Fonts.estiloNoticiaTitulo),
                      subtitle: Column(children: [
                        Text(telefone[1], style: Fonts.estiloNoticiaSite),
                        Text(telefone[2], style: Fonts.estiloTelefone),
                      ]),
                      isThreeLine: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    final String conteudo =
                        telefone[0] + '\n' + telefone[1] + '\n' + telefone[2];
                    System.share(conteudo);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
