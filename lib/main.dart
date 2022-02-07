import 'package:flutter/material.dart';
import 'package:tclearpartner/route_generator.dart';
import 'package:tclearpartner/src/resources/plash_screen.dart';
import 'package:tclearpartner/src/utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TClear Partner',
      theme: ThemeData(
        primarySwatch: green,
        primaryColor: green,
        accentColor: green,
        canvasColor: white,
      ),
      home: PlashScreen(),//App(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}