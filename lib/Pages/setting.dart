import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:re_frame/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:re_frame/Pages/login.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> with MyHomePageStateMixin {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(onPressed: () {
        signOutGoogle();
      }, child: Text('Sign Out', style: TextStyle(fontSize: 20),),),
    );
  }

  Future<void> signOutGoogle() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()),(route) => false);
  }

  @override
  void onPageVisible() {
    MyHomePage
        .of(context)
        ?.params = null;
  }
}
