
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jasaharum/models/user.dart';
import 'package:jasaharum/popupmodel/const.dart';
import 'package:jasaharum/screens/history_order.dart';
import 'package:jasaharum/screens/order_besok.dart';
import 'package:jasaharum/screens/order_hari_ini.dart';
import 'package:jasaharum/services/auth.dart';
import 'package:jasaharum/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> _makePhoneCall(String url) async {
   if (await canLaunch(url)) {
     await launch(url);
   } else {
     throw 'Could not launch $url';
   }
 }

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
  final String textuid;
  const HomeApp({Key key, this.textuid}) : super(key: key);
}

class _HomeAppState extends State<HomeApp> {
bool loading = false; 
  String uid;

  

  getUid() {}

  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      print(val);
      setState(() {
        this.uid = val.uid;
        loading = true;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  final AuthService _auth = AuthService();
  var authku;
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: DefaultTabController(
        
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
            backgroundColor: Color.fromRGBO(44, 53, 140, 1),
            bottom: TabBar(
              
              isScrollable: true,
              tabs: [
                
                new Container(
                  width: 110.0,
                  child: new Tab(child: Text('Order hari ini', style: TextStyle(fontFamily: 'GoogleFont'),),),
                  
                ),
                new Container(
                  width: 120.0,
                  child: new Tab(child: Text('Order untuk besok', style: TextStyle(fontFamily: 'GoogleFont'),),),
                ),
              ],
            ),
            title: Text(
              'Driver Jasa Harum',
              style: TextStyle(
                fontFamily: 'GoogleFont',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              OrderHariIni(),
              OrderBesok(),
            ],
            
            
          ),
          
        ),
      ),
    );
  }
  
}

void choiceAction(String choice) {
  final AuthService _auth = AuthService();
  if (choice == Constants.SignOut) {
    _auth.signOut();
  }else if(choice == Constants.TeleponOperator) {
    _makePhoneCall('tel:081217950820');


  }
}
