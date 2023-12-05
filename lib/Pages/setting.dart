import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:re_frame/main.dart';
import 'package:re_frame/Pages/login.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> with MyHomePageStateMixin {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    try{
      final user = _firebaseAuth.currentUser;
      if(user != null){
        loggedUser = user;
      }
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${loggedUser!.displayName}', style: TextStyle(fontSize: 30, color: Colors.black,)),
        IconButton(onPressed: (){
          signOutGoogle();
        }, icon: const Icon(Icons.logout)),
      ],
    );
  }

  Future<void> signOutGoogle() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),(route) => false);
  }

  @override
  void onPageVisible() {
    MyHomePage
        .of(context)
        ?.params = null;
  }
}
