import 'package:flutter/material.dart';

class SecaoWidget extends StatelessWidget {
  String texto;
  TextStyle style;

  SecaoWidget(this.texto,{this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.red,
        boxShadow: [
          BoxShadow(color: Colors.indigo, offset: Offset(5, 5), blurRadius: 10),
        ],
      ),
      child: Text(texto,
          style: style),
    );
  }
}
