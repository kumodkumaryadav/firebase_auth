import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/model/user.dart';
import 'package:flutter/material.dart';

import '../firebase service/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  String token = '';
  late UserModel userModel;
  //why we need this method ? since we can not call future function directly in to the inItState
  getToken() async {
    token = await Auth().getDeviceIdToken() ?? '';
    setState(() {});
  }

  @override
  initState() {
    getToken();
    setState(() {});

    super.initState();
  }

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
      backgroundImage: NetworkImage(user?.photoURL ?? 'user photo'),
      radius: 50,
    );
  }

  // Widget _userToken() {
  //   return Text(user!.getIdTokenResult() as String );
  // }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: Auth().signOut,
      child: const Text('Sign Out'),
    );
  }

  // Widget AddLinkWidget(){
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        color: const Color.fromARGB(94, 68, 252, 12),
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _userPhoto(),
            _userUid(),
            _signOutButton(),
            // ElevatedButton(onPressed: () async{
            // await Auth().getDeviceIdToken;
            //  print("2222222222222222222222$token");

            // }, child: Text("Get Token")),
            // Text(token)
            StreamBuilder<Object>(
                stream: Auth().getAllDocuments("LogUsers"),
                builder: (context, AsyncSnapshot snapshot) {
                  final List<Map<String, dynamic>> documents = snapshot.data!;

                  debugPrint("555555${documents[0]["email"]}");

                  // userModel=UserModel(email: documents["email"] as String, phoneNumber: "99999999999", userName: "userName", deviceId: documents["token"]);

                  return Expanded(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var dataCollection = documents[index];
                        // UserModel  userModel=UserModel(email: dataCollection["email"], phoneNumber: dataCollection["phone"] ??"", userName: dataCollection["userName"]??"", deviceId: dataCollection["token"]);

                        return InkWell(
                          onTap: () async {
                            await Auth().sendNotification(
                                dataCollection["token"],
                                " notification",
                                "This is body");
                            debugPrint(
                                "token----------------------${dataCollection["token"]}");
                          },
                          child: ListTile(
                            title: Text(dataCollection["email"]),
                            subtitle: const Column(
                              children: [
                                Text("data"),
                                Text("data"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
