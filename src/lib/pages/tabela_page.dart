import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:corona/core/debug.dart' as Debug;
import 'package:corona/core/fonts.dart' as Fonts;
import 'package:corona/core/totalizador.dart';
import 'package:corona/widgets/secao_wiidget.dart';
import 'package:corona/widgets/tabela_dados_widget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class TabelaPage extends StatefulWidget {
  final String nomeArquivoDados = 'database.js';
  String estados;

  @override
  _TabelaPageState createState() => _TabelaPageState();
}

/**
 * O mixim AutomaticKeepAliveClientMixin é o que permite que este objeto NoticiasPageState não seja
 * destruído a cada vez que um Tab é selecionado.
 */
class _TabelaPageState extends State<TabelaPage>
    with AutomaticKeepAliveClientMixin<TabelaPage> {
  Future<Widget> futureDados;
  String dadosMinisterio;

  // Implementação do mixin AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    futureDados = _getDados();
  }

  @override
  Widget build(BuildContext context) {
    // Temos que chamar o super para que o mixin AutomaticKeepAliveClientMixin funcione.
    super.build(context);

    return Container(
      color: Colors.white,
      child: FutureBuilder<Widget>(
        future: futureDados,
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          Widget conteudo;

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              conteudo = snapshot.data;
            } else if (snapshot.hasError) {
              conteudo = _getMensagemErro(snapshot.error.toString());
            }
          } else {
            conteudo = _getProgressoWidget();
          }
          return conteudo;
        },
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
            child: Text('Consultando o sistema do\nMinistério da Saúde...',
                style: Fonts.estiloPadrao, textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }

  Widget _getMensagemErro(mensagemErro) {
    String mensagem =
        'Não foi possível obter os dados sobre o monitoramento do vírus a partir ' +
            'do sistema do Ministério da Saúde.';

    if (Debug.DEBUGGING) {
      mensagem += '\n$mensagemErro';
    }

    return ListView(
      padding: EdgeInsets.only(top: 30),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(mensagem,
                  textAlign: TextAlign.center, style: Fonts.estiloPadrao),
            ),
            if (dadosMinisterio == null) ...[
              Padding(
                padding: EdgeInsets.all(15),
                child: Text('Tente novamente mais tarde.',
                    textAlign: TextAlign.center, style: Fonts.estiloPadrao),
              ),
              RaisedButton(
                child: Text('OK'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  _tentaCarregarNovamente();
                },
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                    'Temos dados armazenados da última medição obtida e vamos exibí-la pra você !',
                    textAlign: TextAlign.center,
                    style: Fonts.estiloPadrao),
              ),
              RaisedButton(
                child: Text('OK'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  _critaTabelaDadosLocais();
                },
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<Widget> _getDados() async {
    dadosMinisterio = await _getDadosLocais();

    if (widget.estados == null) {
      widget.estados = await rootBundle.loadString('assets/estados.json');
    }

    // Obtenha a hora atual
    final DateTime agora = DateTime.now();

    // É antes da hora que normalmente durante a semana o Ministério da Saúde divulga
    // os números sobre o vírus ?
    if (agora.hour < 11) {
      // Temos armazenados o download do último arquivo obtido ?
      if (dadosMinisterio != null) {
        // Forneça os dados locais
        return _processaDados(widget.estados, dadosMinisterio);
      }
    }

    // É depois do horário de divulgação do boletim diário...

    // Temos dados locais ?
    if (dadosMinisterio != null) {
      // Quando foram obtidos ?
      var dadosLocais = jsonDecode(dadosMinisterio);
      dadosLocais = dadosLocais['brazil'];
      // Pegue o último dia de resultados divulgados
      dadosLocais = dadosLocais[dadosLocais.length - 1];

      // Vamos fazer o parsing desta data para extrair o dia
      final DateFormat formato = DateFormat('dd/MM/yyyy', 'pt_BR');
      final DateTime dataHoraDados = formato.parse(dadosLocais['date']);

      // Foram pegos hoje do sistema ?
      final int diaAtual = DateTime.now().day;
      //final int diaAtual = 17;

      // A divulgação do resultado é do dia de hoje ?
      if (dataHoraDados.day == diaAtual) {
        // Forneça os dados locais, eles estão atualizados
        return _processaDados(widget.estados, dadosMinisterio);
      }
    }

    // Vamos adicionar uma pausa aqui para dar tempo da pessoa enxergar
    // a mensagem de espera dizendo que estamos consultando a Internet.
    // Pode ser que ela esteja sem Internet no momento e se não dermos
    // esta pausa, aparecerá já rapidamente a mensagem de erro
    // orientando para tentar novamente e ela não terá uma boa experiencia
    // desta forma. A pausa ajuda a ele entender que o app está
    // sim tentando fazer conexão com a Internet...
    await Future.delayed(new Duration(seconds: 2));

    // Não temos as informações em cache ou estão desatualizadas...
    // Precisamos pegar do sistema do Ministério da Saúde...
    final String urlBase =
        'http://plataforma.saude.gov.br/novocoronavirus/resources/scripts/';
    final String url = urlBase + widget.nomeArquivoDados;
    final response = await http.get(url);

    //await Future.delayed(Duration(seconds: 15));
    //throw Exception('fudeu');

    if (response.statusCode == 200) {
      dadosMinisterio = response.body;
      dadosMinisterio = dadosMinisterio.replaceAll('var database=', '');

      Widget conteudo = _processaDados(widget.estados, dadosMinisterio);

      _gravaDados(dadosMinisterio);

      return conteudo;
    }

    final String mensagem =
        'Erro na comunicação com o sistema do Ministério da Saúde !\n';
    //   'Erro ${response.statusCode}: ' +
    //    response.reasonPhrase;
    throw Exception(mensagem);
  }

  Widget _processaDados(String estados, String dados) {
    try {
      // Tente converter a string recebida para um objeto JSON
      final Map dadosJSON = jsonDecode(dados);

      final Map dadosEstadosJSON = jsonDecode(estados);

      final List<dynamic> medicoesArray = dadosJSON['brazil'];

      return _criaTabelaDados(dadosEstadosJSON, medicoesArray);
    } catch (e) {
      if (Debug.DEBUGGING) {
        debugPrint('Erro durante processamento dos dados: ' + e.toString());
      }
      rethrow;
    }
  }

  Widget _criaTabelaDados(Map dadosEstadosJSON, List medicoesArray) {
    final Map ultimaMedicao = medicoesArray[medicoesArray.length - 1];
    final String dataHoraUltimaAtualizacao =
        ultimaMedicao['date'] + ' às ' + ultimaMedicao['time'];

    final TabelaDadosWidget tabelaResumida = _getTabelaResumida(medicoesArray);

    List<dynamic> estados = [];
    for (int i = 0; i < dadosEstadosJSON['estados'].length; i++) {
      var estado = dadosEstadosJSON['estados'][i];
      estados.add({'id': estado['id'], 'nome': estado['nome']});
    }

    final TabelaDadosWidget tabelaPorEstado =
        _getTabelaPorEstado(estados, ultimaMedicao);

    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Text(
            'Informações divulgadas pelo\nMinistério da Saúde em\n$dataHoraUltimaAtualizacao',
            style: Fonts.estiloPadrao,
            textAlign: TextAlign.center),
        SizedBox(height: 20),
        ExcludeSemantics(
          excluding: true,
          child: SecaoWidget('Últimos casos - consolidado',
              style: Fonts.estiloSecao),
        ),
        tabelaResumida,
        SizedBox(height: 30),
        ExcludeSemantics(
          excluding: true,
          child:
              SecaoWidget('Últimos casos por estado', style: Fonts.estiloSecao),
        ),
        tabelaPorEstado,
      ],
    );
  }

  TabelaDadosWidget _getTabelaResumida(List medicoesArray) {
    final List<String> colunas = [''];

    // Nossas colunas vão se referir aos últimos 7 dias de medições
    List<Map> medicoes = [];
    for (int i = 0; i < 7; i++) {
      Map medicao = medicoesArray[medicoesArray.length - i - 1];
      medicoes.add(medicao);
      colunas.add(medicao['date']);
    }

    final Totalizador totalizador = Totalizador.porCategoria(medicoes);
    final List<List<String>> linhas = totalizador.getLinhasTabela();

    // Monta descrição descrevendo o conteúdo da tabela.
    // Usado para a acessibilidade com o Talkback
    String descricaoTabela = 'Quantidade de casos por categoria\nDados de ' +
        colunas[1] +
        '\n' +
        'Casos ' +
        linhas[0][0] +
        ' são ' +
        linhas[0][1] +
        '\n' +
        'Casos ' +
        linhas[1][0] +
        ' são ' +
        linhas[1][1] +
        '\n' +
        'Casos ' +
        linhas[2][0] +
        ' são ' +
        linhas[2][1] +
        '\n' +
        'e ' +
        linhas[3][0] +
        ' são ' +
        linhas[3][1];

    descricaoTabela += '\nfim da tabela de casos';

    if (Debug.DEBUGGING) {
      debugPrint('semanticsLabel para tabela: $descricaoTabela');
    }

    return TabelaDadosWidget(
        tituloColunas: colunas,
        valoresLinhas: linhas,
        estiloTextoPrimeiraColuna: Fonts.estiloTextoPrimeiraColuna,
        estiloTextoDemaisColunas: Fonts.estiloTextoDemaisColunas,
        semanticsLabel: descricaoTabela);
  }

  TabelaDadosWidget _getTabelaPorEstado(
      List<dynamic> estados, Map ultimaMedicao) {
    final Totalizador totalizador =
        Totalizador.porEstado(estados, ultimaMedicao);
    final List<List<String>> linhas = totalizador.getLinhasTabela();
    final List<String> colunas = [
      'UF',
      'Suspeitos',
      'Confirmados',
      'Descartados',
      'Mortes'
    ];

    // Monta descrição descrevendo o conteúdo da tabela.
    // Usado para a acessibilidade com o Talkback
    String descricaoTabela = 'Quantidade de casos por estado\n';

    for (int i = 0; i < linhas.length; i++) {
      List<String> linha = linhas[i];

      descricaoTabela += linha[0] + ', casos ';

      for (int j = 1; j < colunas.length; j++) {
        descricaoTabela += colunas[j];
        if (j == 1) {
          descricaoTabela += ' são';
        }
        descricaoTabela += ' ' + linha[j];

        if (j < colunas.length) {
          descricaoTabela += ', ';
        } else {
          descricaoTabela += '\n';
        }
      }
    }

    descricaoTabela += 'fim da tabela de casos';

    if (Debug.DEBUGGING) {
      debugPrint(r'semanticsLabel para tabela: $descricaoTabela');
    }

    return TabelaDadosWidget(
        tituloColunas: colunas,
        valoresLinhas: linhas,
        estiloTextoPrimeiraColuna: Fonts.estiloTextoPrimeiraColuna,
        estiloTextoDemaisColunas: Fonts.estiloTextoDemaisColunas,
        semanticsLabel: descricaoTabela);
  }

  Future<String> _getDadosLocais() async {
    //return null;

    try {
      final diretorio = await getApplicationDocumentsDirectory();
      final caminhoCompleto = '${diretorio.path}/${widget.nomeArquivoDados}';
      final arquivo = File(caminhoCompleto);
      final String dadosLocais = await arquivo.readAsString();

      return dadosLocais;
    } catch (e) {
      return null;
    }
  }

  _gravaDados(String dados) async {
    final diretorio = await getApplicationDocumentsDirectory();
    final caminhoCompleto = '${diretorio.path}/${widget.nomeArquivoDados}';
    final arquivo = File(caminhoCompleto);
    await arquivo.writeAsString(dados);
  }

  void _critaTabelaDadosLocais() {
    _getDadosLocais().then((dadosLocais) => {
          setState(() {
            _processaDados(widget.estados, dadosLocais);
          })
        });
  }

  void _tentaCarregarNovamente() {
    futureDados = _getDados();

    setState(() {});
  }
}
