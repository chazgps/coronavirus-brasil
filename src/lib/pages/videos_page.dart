import 'package:corona/core/cores.dart' as Cores;
import 'package:corona/core/card_library.dart' as Card;
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosPage extends StatefulWidget {
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage>
    with AutomaticKeepAliveClientMixin<VideosPage> {
  final List<List<String>> listaVideos = [
    [
      'Coronavírus: infectologista tira todas as dúvidas no Primeiro Jornal',
      'kwcHnSs3A_w'
    ],
    [
      'Esse médico vai tirar suas dúvidas sobre o novo coronavírus',
      'sFFwd4FbhaI'
    ],
    ['Coronavírus: O que muda com a chegada ao Brasil', 'TbVapVcdEqU'],
    ['Dr. Sproesser explica como se prevenir do coronavírus', 'nz9at_gk8Rw'],
    ['Coronavírus | Como se proteger do vírus', 'g2KLA7WykDo'],
    ['Entenda o que é o coronavírus', 'YXff2k_J_2A']
  ];

  // Implementação do mixin AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: Cores.corFundoPagina,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: List.generate(
                listaVideos.length,
                (index) {
                  return _getVideo(context, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getVideo(BuildContext context, int index) {
    final String titulo = listaVideos[index][0];

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: listaVideos[index][1],
      flags: YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        autoPlay: false,
        mute: false,
      ),
    );

    final YoutubePlayer player = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );

    return Card.getCard(titulo, null, player);
  }
}
