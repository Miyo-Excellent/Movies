import 'package:flutter/material.dart';
import 'package:movies_app/pages/Detail.dart';
import 'package:movies_app/pages/Home.dart';

void main() => runApp(Movies());

class Movies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Home(),
        //  'detail': (BuildContext context) => Detail()
      },
    );
  }
}

