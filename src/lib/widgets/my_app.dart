import 'package:flutter/material.dart';
import 'package:corona/core/debug.dart' as Debug;
import 'package:corona/core/strings.dart' as Strings;
import 'package:corona/pages/principal_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      title: Strings.APP_NAME,
      debugShowCheckedModeBanner: Debug.DEBUGGING,
      theme: ThemeData(fontFamily: 'sofia',
        primarySwatch: Colors.indigo,
      ),
      home: PrincipalPage(),
    );
  }
}
