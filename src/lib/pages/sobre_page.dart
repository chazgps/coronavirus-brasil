import 'package:flutter/material.dart';
import 'package:corona/core/debug.dart' as Debug;
import 'package:corona/core/fonts.dart' as Fonts;
import 'package:corona/core/system.dart' as System;
import 'package:package_info/package_info.dart';

class SobrePage extends StatefulWidget {
  @override
  _SobrePageState createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  Future<String> futureVersao;

  @override
  void initState() {
    super.initState();

    futureVersao = _getVersaoApp();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String>(
                        future: futureVersao,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          Widget conteudo;
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              conteudo = _getWidgetsSucesso(snapshot.data);
                            } else if (snapshot.hasError) {
                              conteudo =
                                  _getMensagemErro(snapshot.error.toString());
                            }
                          } else {
                            conteudo = _getProgressoWidget();
                          }
                          return conteudo;
                        })
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getProgressoWidget() {
    return Center(
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
            child: Text('Consultando algumas informações sobre o aplicativo...',
                style: Fonts.estiloPadrao, textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }

  Widget _getWidgetsSucesso(String versaoApp) {
    return Column(
      children: [
        MergeSemantics(
          child: Column(children: [
            Image.asset('assets/images/logo.png', excludeFromSemantics: true),
            Text('Versão '+versaoApp,
                style: Fonts.estiloPadrao),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, bottom: 30),
          child: OutlineButton(
            textColor: Colors.indigo,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            onPressed: _compartilharApp,
            child: Text(
              'Compartilhe este app com um amigo !',
              textAlign: TextAlign.center,
              style: Fonts.estiloPadrao,
            ),
          ),
        ),
        Text(_getSobreApp(),
            style: Fonts.estiloPadrao, textAlign: TextAlign.center),
        _getSeparador(),
        Text(_getCopyrightImagemCorona(),
            style: Fonts.estiloPadrao, textAlign: TextAlign.center),
      ],
    );
  }

  String _getSobreApp() {
    return 'O objetivo deste app é reunir informações confiáveis sobre o Coronavírus para ' +
        'auxiliar o cidadão na concientização sobre o vírus e facilitar o acesso à população ' +
        'como um todo a informação confiável.\n\n' +
        'As informações e notícias exibidas neste aplicativo são coletadas de sites de orgãos e governos ' +
        'municipais, estaduais e federal.';
  }

  Widget _getMensagemErro(mensagemErro) {
    String mensagem =
        'Não foi possível obter os dados sobre o aplicativo, pedimos desculpas por isso.';

    if (Debug.DEBUGGING) {
      mensagem += '\n$mensagemErro';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Text(mensagem,
              textAlign: TextAlign.center, style: Fonts.estiloPadrao),
        ),
      ],
    );
  }

  Future<String> _getVersaoApp() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  void _compartilharApp() {
    //final String package = 'com.whatsapp';
    final String package = 'charlesgps.coronavirus';
    final String urlBase = 'https://play.google.com/store/apps/details?id=';
    final String url = urlBase + package;
    System.share(url);
  }

  String _getCopyrightImagemCorona() {
    return 'Ilustração do Coronavírus: Alissa Eckert, MS, Dan Higgins, MAM\n' +
        'Centers for Disease Control and Prevention (CDC)';
  }

  Widget _getSeparador() {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Divider(color: Colors.grey, indent: 30, endIndent: 30),
    );
  }
}
