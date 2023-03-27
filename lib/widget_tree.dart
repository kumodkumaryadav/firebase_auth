import 'package:firebase_login/auth.dart';
import 'package:firebase_login/home_page.dart';
import 'package:firebase_login/loginscreen.dart';
import 'package:flutter/material.dart';


class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        if(snapshot.hasData){
          return HomePage();
        }
        else {
          return LoginPage();
        }
       },);
  }
}