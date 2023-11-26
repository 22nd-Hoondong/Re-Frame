import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final uid;

  FriendRepository() {
    init();
  }

  Future<void> init() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<Map<String, dynamic>>> getFriends() {
    var snapshot = _firestore
        .collection('users')
        .doc(uid)
        .collection('friends').get();

    return snapshot.then((value) => value.docs.map((e) => e.data()).toList());
  }
}
