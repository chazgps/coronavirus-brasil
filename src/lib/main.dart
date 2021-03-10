import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:corona/widgets/my_app.dart';
import 'package:corona/core/config.dart';
import 'package:corona/core/debug.dart' as Debug;

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool sincronizacaoLigada = await Config().getBool(Config.SINCRONIZAR);

  if (!sincronizacaoLigada) {
    await Firestore.instance.settings(host: '192.168.0.0:8080');

    if (Debug.DEBUGGING)
    {
      debugPrint('Firebase operando em modo off-line.');
    }
  }

  // Inicializando a biblioteca para tratamento de formatos de data/hora
  await initializeDateFormatting('pt_BR', null);

  runApp(MyApp());
}
