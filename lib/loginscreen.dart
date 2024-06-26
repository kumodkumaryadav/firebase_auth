import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/auth.dart';
import 'package:firebase_login/input_number.dart';
import 'package:flutter/material.dart';

import 'otp_screen.dart';


class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';

  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();

  final TextEditingController _controllerPassword = TextEditingController();
  //method for sign in with email and password
  // Future<void> signInWithEmailAndPassword() async {
  //   try {
  //     await Auth().signInWithEmailAndPassword(
  //         email: _controllerEmail.text, password: _controllerPassword.text);
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       errorMessage = e.message;
  //     });
  //   }
  // }

  //method for creating user and password
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
  }




 
  


  Widget _title() {
    return Text("FireBase Auth");
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: title),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Hmmm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? () => Auth().signInWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text)
            : () => Auth().createUserWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text),
        child: Text(isLogin ? "Logn" : "Register"));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: (() {
          setState(() {
            isLogin = !isLogin;
          });
        }),
        child: Text(isLogin ? 'Register Instead' : 'Login Instead'));
  }

  Widget _signInWithGoogleButton(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Sign in With Google"),
          Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/768px-Google_%22G%22_Logo.svg.png",height: 40,width: 40,)
        ],
      ),
    );
  }

  Widget _logInOTP(){
    return Container(
      height: 40,
      width: 200,
      child: Center(child: Text("Sign in with Mob Numbers")),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
            GestureDetector(
              onTap: (){
                Auth().signInWithGoogle();
              },
              child: _signInWithGoogleButton()),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InputNumber(),));
                },
                child: _logInOTP())

          ],
        ),
      ),
    );
  }
}
