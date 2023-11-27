import 'package:cloud_firestore/cloud_firestore.dart';

class FriendInfo {
  late String name;
  late String uid;
  late String email;

  FriendInfo(this.name, this.uid, this.email);

  static FriendInfo fromJson(Map<String, dynamic> e) {
    return FriendInfo(e['name'], e['id'], e['email']);
  }

  FriendInfo.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    name = data['name'];
    uid = data['uid'];
    email = data['email'];
  }

  Map<String, dynamic> toSnapshot() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['uid'] = uid;
    data['email'] = email;
    return data;
  }
}