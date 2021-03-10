library system;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void share(String content)
{
  Share.share(content);
}

String getDataDeDateTime(DateTime dataHora)
{
  //final DateFormat formato = DateFormat("EEEE, dd/MM/yyyy H:mm", 'pt_BR');
  final DateFormat formato = DateFormat("dd/MM/yy H:mm", 'pt_BR');
  final String dataFormatada = formato.format(dataHora);
  return dataFormatada;
}
