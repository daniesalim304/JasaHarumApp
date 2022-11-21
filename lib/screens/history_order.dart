import 'package:flutter/material.dart';

class DaftarOrder extends StatefulWidget {
  @override
  _DaftarOrderState createState() => _DaftarOrderState();
}

class _DaftarOrderState extends State<DaftarOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.check, color: Color.fromRGBO(21, 25, 101, 1),),
              title: Text("Data", style: TextStyle(color: Color.fromRGBO(21, 25, 101, 1)),)
            ),
            ListTile(
              leading: Icon(Icons.check, color: Color.fromRGBO(21, 25, 101, 1)),
              title: Text("Data", style: TextStyle(color: Color.fromRGBO(21, 25, 101, 1)),)
            ),
            ListTile(
              leading: Icon(Icons.check, color: Color.fromRGBO(21, 25, 101, 1)),
              title: Text("Data", style: TextStyle(color: Color.fromRGBO(21, 25, 101, 1)),)
            ),
          ],
        ),
    );
  }
}
