import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:re_frame/Models/post_model.dart';
import 'package:re_frame/Models/photo_model.dart';

class User {
  late List<Photo> home;
  late String name;

  User({
    required this.home,
    required this.name,
  });

  User.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data['home'] != null) {
      home = List<Photo>.empty(growable: true);
      data['home'].forEach((photo) {
        home.add(Photo.fromSnapshot(photo));
      });
    }
    name = data['name'];
  }

  Map<String, dynamic> toSnapshot() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (home != null) {
      data['home'] = home.map((photo) => photo.toSnapshot()).toList();
    }
    data['name'] = name;
    return data;
  }
}