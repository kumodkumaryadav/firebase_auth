

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Auth {
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
User? get currentUser=> _firebaseAuth.currentUser;
Stream<User?> get authStateChanges=>_firebaseAuth.authStateChanges();
final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
late  UserCredential userCredential;


//*************Login/SignUp methods */

//method for signing via EmailPassword 
Future<void> signInWithEmailAndPassword({
  required String email,
  required String password,

}) async{
  await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password, );
  // await firebaseFirestore.collection("UsersData").doc(currentUser!.uid).set({
  //   "email" : currentUser!.email,
  //   "uid" : currentUser!.uid,
  //   "token" :getDeviceIdToken(),
  // });
  // await createDocument("LogUsers", {
  //   "email" : currentUser!.email,
  //   "uid" : currentUser!.uid,
  //   "token" : await getDeviceIdToken(),
  // });
  // print("uid----------------------------------${currentUser!.uid}");
  // print("uid----------------------------------${await getDeviceIdToken()}");
}

//method for signUp via email password
Future<void> createUserWithEmailAndPassword({
  required String email,
  required String password
}) async{
 userCredential= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
//  await firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set({
// "email" :userCredential.user!.email,
// "uid" : userCredential.user!.uid,
// "token":getDeviceIdToken()
//  });
//  print("uid ${userCredential.user!.uid}");
//  print("email${userCredential.user!.email}");
//  print("token id from method $getDeviceIdToken");
await createDocument("LogUsers", {
    "email" : currentUser!.email,
    "uid" : currentUser!.uid,
    "token" : await getDeviceIdToken(),
  });

}

//method for signing via direct google
Future signInWithGoogle()async{
  final GoogleSignInAccount? googleUser= await GoogleSignIn(
    scopes: <String> ["email"]).signIn();

  final GoogleSignInAuthentication googleAuth=await googleUser!.authentication;
  final credential =GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken);
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
//method for getting token
Future<String?> getDeviceIdToken() async {
  String? token;
   await     firebaseMessaging.getToken()
.then((result){
      token=result;
      
    });
    return  token;
}
String verificationId="";

veryfyPhoneNumber(String phoneNumner)async {
  await _firebaseAuth.verifyPhoneNumber(
    phoneNumber: phoneNumner,
    timeout: const Duration(seconds: 60),
    verificationCompleted: (AuthCredential authCredential){
      
    },
     verificationFailed: (FirebaseAuthException exception){}, 
     codeSent: (String? verId, int? codeForceReSend){
      verificationId=verId!;
     }, 
     codeAutoRetrievalTimeout: (String verId){});
}

signInWithPhone(String smsCode)async{
 return await _firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode));
}
//method for signOut
Future<void> signOut() async{
  await _firebaseAuth.signOut();
}


//Firestore cloud methods
//create document

 Future<void> createDocument(String collection, Map<String, dynamic> data) async {
    try {
 await firebaseFirestore.collection(collection).add(data);


    } catch (e) {
      debugPrint('Error creating document: $e');
    }
  }

  //read/get method for firestore data
    Stream<List<Map<String, dynamic>>> getAllDocuments(String collection) {
    try {
      return firebaseFirestore.collection(collection).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      debugPrint('Error getting all documents: $e');
      return const Stream.empty();
    }
  }
//firebase cloud messaging or push notifications method

Future<void> sendNotification(String token, String title, String body) async {
  const String serverKey = 'AAAApJ7pjYI:APA91bGiv-qDO1jduA2cdMpdAvVXX0z1jeitLr6aOzXWp5yGTvaFbwDKP52a6tV9itHFMmXHjMx58ovGrI3X6ZFOANRUTAYWNPjFJrO70O45xo3_giQHzkP1Wtjpol0oIS_R5zR5VK1S'; // Replace with your FCM server key

  final Map<String, dynamic> notification = {
    'to': token,
    'notification': {
      'title': title,
      'body': body,
    },
  };

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: headers,
    body: jsonEncode(notification),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
    print(response.body);
  } else {
    print('Error sending notification: ${response.statusCode}');
  }
}



}

