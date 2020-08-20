import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube/Login_page.dart';
import 'package:youtube/home_page.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _isnit = true;
  var isLoading = false;
  var _isLogin = false;
  var prefs;
  @override
  void initState() {
    Timer _timer;

    _timer = Timer(const Duration(seconds: 5), () {});
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isnit) {
      setState(() {
        isLoading = true;
      });
      prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('userAuth')) {
        _isLogin = true;
      } else {
        _isLogin = false;
      }
    }
    setState(() {
      isLoading = false;
    });
    if (_isLogin) {
      Future.delayed(Duration(seconds: 2), () {
        !isLoading
            ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => HomePage()))
            : null;
      });
    } else {
      Future.delayed(Duration(seconds: 2), () {
        !isLoading
            ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => LoginPage()))
            : null;
      });
    }
    _isnit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 300,
          ),
          Container(
            height: 200,
            width: 200,
            child: Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_youtube_ios_%28cropped%29.jpg",
              fit: BoxFit.fill,
              filterQuality: FilterQuality.low,
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      ),
    ));
  }
}
