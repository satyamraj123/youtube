import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _isInit=true;
  SharedPreferences prefs;
  var userAuth;
  var _isLoading=false;
  @override
  Future<void> didChangeDependencies() async{
    setState(() {
    _isLoading=true;  
    });
    
    if(_isInit){

     prefs=await SharedPreferences.getInstance();
     userAuth=json.decode(prefs.getString('userAuth'));
    }
    setState(() {
    _isLoading=false;  
    });
    
    _isInit=false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: 180,
          child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child:  Image.network("https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Hitman_4_artwork.jpg/220px-Hitman_4_artwork.jpg",
                      fit: BoxFit.fill,
                      cacheHeight: 100,
                      cacheWidth: 100,

                      ),
            radius: 70,
          )),
        ),
        
        Text("Name"),
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2),left: BorderSide(width: 2),right: BorderSide(width: 2),top: BorderSide(width: 2),)),
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(_isLoading?"email":userAuth['email'].toString()),
              Text("Name"),
              Text("Work"),
              Text("phone"),
              Text("Bio"),
            ],
          ),
        ),
        Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Genre",style: TextStyle(fontSize: 30),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.cyan),
                    child: Center(
                        child: Text(
                      "Food",
                      style: TextStyle(
                        fontSize: 20,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.cyan),
                    child: Center(
                        child: Text(
                      "Meme",
                      style: TextStyle(fontSize: 20,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.cyan),
                    child: Center(
                        child: Text(
                      "Fitness",
                      style: TextStyle(fontSize: 20,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.cyan),
                    child: Center(
                        child: Text(
                      "Beauty",
                      style: TextStyle(fontSize: 20,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
