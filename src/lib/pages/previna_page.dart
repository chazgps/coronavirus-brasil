import 'package:flutter/material.dart';
import 'package:corona/core/card_library.dart' as Card;

class PrevinaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card.getPage(
      _getConteudoPagina(),
    );
  }

  List<Widget> _getConteudoPagina() {
    return [
      _getCardSintomas(),
      _getCardCuidados(),
      _getCardOqueFazer()
    ];
  }

  _getCardSintomas() {
    final String titulo = 'Quais os sintomas devo prestar atenção ?';

    final String mensagem =
        'Se você tiver um ou mais dos sintomas abaixo e principalmente se teve contato ' +
            'com alguém infectado ou esteve em uma das áreas com casos de contaminação confirmada:';

    final List<List<String>> conteudo = [
      ['febre', 'Febre'],
      ['tosse', 'Tosse'],
      ['dificuldade-respirar', 'Dificuldade para respirar'],
    ];

    return Card.getCard(titulo, mensagem,conteudo);
  }

  _getCardCuidados() {
    final String titulo = 'Que cuidados devo ter ?';

    List<List<String>> conteudo = [];

    String imagem = 'ao-espirrar';
    String orientacao =
        'Ao espirrar, cubra o nariz e a boca com um lenço descartável.' +
            'Se não tiver um, espirre no no cotovelo dobrado ou na manga da roupa';
    conteudo.add([imagem, orientacao]);

    imagem = 'lave-as-maos';
    orientacao =
        'Lave as mãos: depois de tossir, espirrar, cuidar de pessoas doentes, ' +
            'ir ao banheiro,antes de comer;';
    conteudo.add([imagem, orientacao]);

    imagem = 'evite-locais';
    orientacao =
        'Evite locais com muitas pessoas juntas, principalmente se alguma manifestar um dos sintomas da doença;';
    conteudo.add([imagem, orientacao]);

    imagem = 'mantenha-limpo';
    orientacao =
        'Limpe e desinfete objetos e superfícies tocados com frequência;';
    conteudo.add([imagem, orientacao]);

    imagem = 'objetos-pessoais';
    orientacao = 'Não use objetos de uso pessoal de outras pessoas;';
    conteudo.add([imagem, orientacao]);

    return Card.getCard(titulo,null, conteudo,);
  }

  _getCardOqueFazer() {
    final String titulo = 'O que fazer se eu apresentar os sintomas do vírus ?';

    final String textao =
        '► Fique em casa e evite contato com pessoas quando estiver doente;\n' +
            '► Peça alguém para comprar uma máscara para você;\n' +
            '► Use a máscara mesmo dentro de casa para não correr o risco de transmitir o vírus para seus familiares;\n' +
            '► Mantenha-se isolado em um cômodo da residência e peça para somente uma pessoa da família, te atender ' +
            'no que você necessitar, assim você diminui as chances de contaminar outros membros da família;\n' +
            '► Procure uma unidade básica de saúde;';

    return Card.getCard(titulo, textao,null);
  }
}
