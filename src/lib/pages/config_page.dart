import 'package:flutter/material.dart';
import 'package:corona/core/config.dart';
import 'package:corona/core/fonts.dart' as Fonts;
import 'package:corona/core/system.dart' as System;
import 'package:flutter/services.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool sincronizacaoLigada;
  Future<bool> futureConfig;

  @override
  void initState() {
    super.initState();

    futureConfig = _getConfiguracoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: FutureBuilder<bool>(
        future: futureConfig,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          Widget conteudo;
          if (snapshot.hasData) {
            conteudo = _getWidgetsSucesso(context);
          } else {
            conteudo = _getProgressoWidget();
          }
          return conteudo;
        },
      ),
    );
  }

  Future<bool> _getConfiguracoes() async {
    sincronizacaoLigada = await Config().getBool(Config.SINCRONIZAR);

    return true;
  }

  _getWidgetsSucesso(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
          child: Column(
            children: [
              _getPainelSincronizacao(context),
              Divider(),
            ],
          ),
        ),
      ],
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

  _getPainelSincronizacao(BuildContext context) {
    final String mensagem =
        'Você pode desligar ou ligar a obtenção de novas notícias.\n' +
            'Desligar ajuda a economizar seu plano de dados e bateria, ' +
            'mas você ficará sem novas notícias até que religue esta configuração.';

    return SwitchListTile(
      title: Text(
        mensagem,
        style: TextStyle(fontSize: 18),
      ),
      value: sincronizacaoLigada,
      onChanged: (bool valor) =>
          {_alterarConnectividadeFirebase(context, valor)},
    );
  }

  _alterarConnectividadeFirebase(BuildContext contexto, bool valor) {
    setState(() {
      sincronizacaoLigada = valor;
      Config().salvarConfiguracao(Config.SINCRONIZAR, sincronizacaoLigada);
    });

    final String mensagem =
        'Para esta alteração passar a fazer efeito é necessário ' +
            'fechar este aplicativo e entrar novamente.\n\n' +
            'Você deseja encerrar o aplicativo agora ?';

    showDialog(
      context: contexto,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Atenção", style: Fonts.estiloPadrao),
          content: new Text(mensagem, style: Fonts.estiloPadrao),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text('Não', style: Fonts.estiloPadrao),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Sim', style: Fonts.estiloPadrao),
              onPressed: () {
                SystemNavigator.pop(animated: false);
              },
            ),
          ],
        );
      },
    );
  }
}
