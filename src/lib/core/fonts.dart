library fonts;

import 'package:flutter/material.dart';

const TextStyle estiloPadrao = TextStyle(fontSize: 24);

const TextStyle estiloAba = TextStyle(fontSize: 20);

const TextStyle estiloNoticiaTitulo =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

const TextStyle estiloNoticiaSite =
    TextStyle(fontSize: 18, fontFamily: 'sofia');

const TextStyle estiloNoticiaData = TextStyle(fontSize: 14);

const TextStyle estiloTelefone =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue);

// -----------------------
// Estilo para o widget SecaoWidget
const TextStyle estiloSecao = TextStyle(
// shadows: [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18);

// -----------------------
// Estilos para o DataTable

const TextStyle estiloTabela = TextStyle(fontSize: 20);

const TextStyle estiloTextoPrimeiraColuna =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

const TextStyle estiloTextoDemaisColunas = TextStyle(fontSize: 20);

// -----------------------
const TextStyle estiloFaqCardTitulo =
    TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold);

const TextStyle estiloFaqCardCorpo = TextStyle(
  color: Colors.black,
  fontSize: 22,
);

const TextStyle estiloFaqCardImagem =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
