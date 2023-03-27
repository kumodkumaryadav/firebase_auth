import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _userPhoto() {
    return CircleAvatar(
      backgroundImage:  NetworkImage(user?.photoURL ?? 'user photo')   ,
      radius: 50,
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }
  Widget _shaveUrlButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent
      ),
      onPressed: (){}, child: Text("Save", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),));
  }

  Widget _addLinkButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              //  borderRadius:   BorderRadius.circular(10.0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget> [
                    Text("Add Your Link below", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      width: 250,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            
                           borderRadius: BorderRadius.circular(10) 
                          ),
                          labelText: "Link or Url",
                          hintText: "www.instagram.com/@kumod_kmd"
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      width: 250,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            
                           borderRadius: BorderRadius.circular(10) 
                          ),
                          hintText: "Instagram",
                          labelText: "Title"
                        ),
                      ),
                    ),
                    _shaveUrlButton()
                  ],
                ),
              );
            },
          );
        },
        child: Text("Add Link"));
  }

  Widget _linkSection(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        )),
      ),
    );
  }

  // Widget AddLinkWidget(){
  //   return  BottomSheet(onClosing: onClosing, builder: builder);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        color: Color.fromARGB(94, 68, 252, 12),
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _userPhoto(),
            _userUid(),
            _signOutButton(),
            _addLinkButton(context),
            SizedBox(
              height: 20,
            ),
            _linkSection("InstaGram"),
            _linkSection("YouTube"),
            _linkSection("SnapChat"),
            // _linkSection("SnapChat"),
            // _linkSection("SnapChat"),
            // _linkSection("SnapChat"),
          ],
        ),
      ),
    );
  }
}
