import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:youtube/home_page.dart';

class HttpException implements Exception {
  final message;
  HttpException(this.message);
  @override
  String toString() {
    return message;
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var isLoading = false;
  final _formkey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String _userEmail = '';

  String _userPassword = '';
  var _token;
  var _userId;
  var _expiryDate;
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBPGru-PSqcAKjaKGzxfOPJRDvAWf3rWmw';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      final userAuth = json.encode(
          {'email': _userEmail, 'userId': _userId, 'password': _userPassword});
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userAuth', userAuth);
      responseData['error'] == null
          ? Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()))
          : null;
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Okay'))
            ],
          ));
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userAuth')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userAuth')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    return true;
  }

  void _trySubmit() {
    final isValid = _formkey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState.save();
      if (_isLogin) {
        login(_userEmail, _userPassword);
      } else {
        signup(_userEmail, _userPassword);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: 300,
          ),
          Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 200,
                        child: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_youtube_ios_%28cropped%29.jpg",
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.low,
                        ),
                      ),
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid Email Address';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email Address'),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                      TextFormField(
                        key: ValueKey('password'),
                        controller: _passwordController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Password must be atleast 6 characters long.';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                        onSaved: (value) {
                          _userPassword = value;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey('password'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 6) {
                              return 'Password must be atleast 6 characters long.';
                            } else if (value.toString() !=
                                _passwordController.text.toString()) {
                              return 'Password do not match';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          onSaved: (value) {
                            _userPassword = value;
                          },
                        ),
                      SizedBox(
                        height: 12,
                      ),
                      isLoading
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              color: Colors.red,
                              child: Text(_isLogin ? 'Login' : 'Signup',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              onPressed: _trySubmit,
                            ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(_isLogin
                            ? 'Haven\'t registered yet? '
                            : 'Already have an Account?'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
