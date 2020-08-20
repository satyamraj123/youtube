import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:youtube/categories_model.dart';

import 'package:youtube/splash_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => CategoriesList(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CategoriesList()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: "CM",
            backgroundColor: Color.fromRGBO(89, 89, 89, 0),
            primaryColor: Colors.green,
            accentColor: Colors.greenAccent,
            bottomAppBarColor: Colors.green,
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.green)),
        home: SplashScreen(),
      ),
    );
  }
}
