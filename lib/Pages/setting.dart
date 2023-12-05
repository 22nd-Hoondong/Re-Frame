import 'package:cloud_firestore/cloud_firestore.dart';
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

class _SettingState extends State<Setting> with AutomaticKeepAliveClientMixin, MyHomePageStateMixin {

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            child: Text('${loggedUser!.displayName}', style: TextStyle(fontSize: 30, color: Colors.black,))
        ),
        SizedBox(height: 10,),
        Container(
            child: Text('${loggedUser!.email}', style: TextStyle(fontSize: 15, color: Colors.black,))
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(onPressed: (){
              signOutGoogle();
            }, child: const Text('로그아웃'),
            style: OutlinedButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.white,
              shadowColor: Colors.grey,
              elevation: 3,
              side: BorderSide(color: Colors.transparent),
              padding: EdgeInsets.symmetric(horizontal: 30),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            )),
            SizedBox(width: 30,),
            OutlinedButton(onPressed: (){
              deleteAccount();
            }, child: const Text('회원 탈퇴'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 3,
                  side: BorderSide(color: Colors.transparent),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                )),
          ],
        ),
        SizedBox(height: 20,),
        Text('ⓒ 2023. RE:Frame All Rights Reserved.', style: TextStyle(color: Colors.grey,)),
      ],
    );
  }

  Future<void> signOutGoogle() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()),(route) => false);
  }

  Future<void> deleteAccount() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(loggedUser!.uid).delete();
    loggedUser?.delete();
    await signOutGoogle();
  }

  @override
  void onPageVisible() {
    MyHomePage.of(context)?.params = AppBarParams();
  }

  @override
  bool get wantKeepAlive => true;
}
