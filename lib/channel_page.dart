import 'package:flutter/material.dart';

class ChannelPage extends StatefulWidget {
  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("This is Channel Page",
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    );
  }
}
