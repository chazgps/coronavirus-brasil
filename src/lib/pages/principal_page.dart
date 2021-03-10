import 'package:corona/pages/config_page.dart';
import 'package:corona/pages/previna_page.dart';
import 'package:corona/pages/sobre_virus_page.dart';
import 'package:corona/pages/telefones_page.dart';
import 'package:corona/pages/videos_page.dart';
import 'package:flutter/material.dart';
import 'package:corona/core/strings.dart' as Strings;
import 'package:corona/core/fonts.dart' as Fonts;
import 'noticias_page.dart';
import 'sobre_page.dart';
import 'tabela_page.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          elevation: 15,
          actions: <Widget>[
            Semantics(
              label: 'Sobre este app',
              child: IconButton(
                splashColor: Color(0xFF002776),
                color: Color(0xFF002776),
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ConfigPage()));
                },
              ),
            ),
            Semantics(
              label: 'Sobre este app',
              child: IconButton(
                splashColor: Color(0xFF002776),
                color: Color(0xFF002776),
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SobrePage()));
                },
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF002776),
                Color(0xFF009b3a),
                Color(0xFFfedf00)
              ]),
            ),
          ),
          title: Semantics(
              hint: 'nome do aplicativo',
              child: Text(Strings.APP_NAME, style: Fonts.estiloPadrao)),
          bottom: TabBar(
            labelPadding: EdgeInsets.only(left: 5, right: 10),
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 6.0, color: Colors.yellow),
                insets: EdgeInsets.symmetric(horizontal: 0.0)),
            tabs: <Widget>[
              _getTab('Notícias'),
              _getTab('Casos'),
              _getTab('Vídeos'),
              _getTab('Telefones'),
              _getTab('Previna-se'),
              _getTab('Sobre o vírus'),
            ],
          ),
        ),
        body: _getConteudo(),
      ),
    );
  }

  _getTab(String texto) {
    return Tab(
      child: Semantics(
        hint: 'aba',
        child: Text(
          texto,
          style: Fonts.estiloAba,
        ),
      ),
    );
  }

  _getConteudo() {
    return TabBarView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        NoticiasPage(),
        TabelaPage(),
        VideosPage(),
        TelefenosPage(),
        PrevinaPage(),
        SobreVirusPage(),
      ],
    );
  }
}
