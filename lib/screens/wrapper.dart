import 'package:flutter/material.dart';
import 'package:jasaharum/home.dart';
import 'package:jasaharum/screens/home/login_page.dart';
import 'package:provider/provider.dart';
import 'package:jasaharum/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null){
      return SignIn();
    }else{
      return HomeApp(textuid: user.uid.toString(),);
    }
  }
}