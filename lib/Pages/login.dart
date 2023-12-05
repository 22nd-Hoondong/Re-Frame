import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:re_frame/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MyHomePageStateMixin {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Testing',
        home: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xffFFC1B4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Image.asset('images/Re-Frame_Logo.png',
                    width: 300,
                    height: 300,
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Image.asset('images/sign_in_button.png'),
                ),
              ],
            ),
          ),
        )
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential loginResult = await FirebaseAuth.instance.signInWithCredential(credential);
    final String? uid = loginResult.user?.uid;    // firestore key 값
    final String? displayName = loginResult.user?.displayName;  // name으로 필드에 추가
    final String? email = loginResult.user?.email;
    print(uid);

    // 별도 회원가입 로직 XX
    DocumentSnapshot signedUpUser = await db.collection("users").doc(uid).get();

    if (!signedUpUser.exists) {
      CollectionReference users = db.collection('users');
      users.doc(uid).set({'name': displayName, 'email': email, 'uid': uid});
    }

    // Once signed in, return the UserCredential
    return loginResult;
  }

  @override
  void onPageVisible() {
    print('changed to login');
  }
}



