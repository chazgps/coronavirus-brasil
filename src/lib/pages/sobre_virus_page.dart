import 'package:flutter/material.dart';
import 'package:corona/core/card_library.dart' as Card;

class SobreVirusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card.getPage(
      _getConteudoPagina(),
    );
  }

  List<Widget> _getConteudoPagina() {
    return [
      _getCardOque(),
      _getCardEsseTalCorona(),
      _getCardVirusJaChegou(),
      _getCardComoPego()
    ];
  }

  _getCardOque() {
    final String titulo = 'O que é Coronavírus ?';

    final String textao = 'É uma família de vírus que causam infecções respiratórias.\n' +
        'A maioria das pessoas se infecta com os coronavírus comuns ao longo da vida, ' +
        'sendo as crianças pequenas mais propensas a se infectarem com o tipo mais comum do vírus. ' +
        'Os coronavírus mais comuns que infectam humanos são o alpha coronavírus 229E e NL63 e beta coronavírus OC43, HKU1.';

    return Card.getCard(titulo, textao, null);
  }

  _getCardEsseTalCorona() {
    final String titulo = 'E esse Coronavírus que todo mundo fala, o que é ?';

    final Image imagem =Image.asset(
      'assets/images/coronavirus.png',
      semanticLabel: 'Imagem simulada do coronavírus',
    );

    final String textao =
        'É um novo coronavírus descoberto no fim de dezembro de 2019 na China, ' +
            'mais precisamente na cidade de Wuhan, Província de Hubei.\n' +
            'Até então, não havia sido identificado sua presença em humanos.\n' +
            'Este novo vírus foi denonimado pela Organização Mundial da Saúde como SARS-CoV2 ' +
            'e a doença por ele causada, COVID-19.';

    return Card.getCard(titulo, textao, imagem);
  }

  _getCardVirusJaChegou() {
    final String titulo = 'O vírus já chegou ao Brasil ?';

    final String textao = 'Sim, em 25 de fevereiro de 2020, um brasileiro que voltou ' +
        'de uma viagem a Itália, procurou o Hospital Albert Einstein e exame ' +
        ' posterior laboratorial confirmou a contaminação pelo novo coronavírus.';

    return Card.getCard(titulo, textao, null);
  }

  _getCardComoPego() {
    final String titulo = 'Como eu pego este vírus ?';

    final String textao = '► Através do ar, se nele houver gotículas de saliva contaminada.\n' +
        'Por exemplo, se alguém tosse ou espirra, estas gotículas ficarão suspensas no ar durante algum tempo.' +
        'Se você estiver neste ambiente, poderá ter contato com estas gotículas;\n' +
        '► Através do contato físico com uma pessoa contaminada, por exemplo, num aperto de mão,' +
        'levando depois a mão contaminada aos olhos, boca ou nariz. Beijo é outra forma de contaminação ' +
        'já que existe a troca de saliva;\n' +
        '► Tocar em superfícies de objetos contaminados;';

    return Card.getCard(titulo, textao, null);
  }
}
