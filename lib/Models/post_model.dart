import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:re_frame/Models/friend_model.dart';
import 'package:re_frame/Models/photo_model.dart';

class Post {
  late String content;
  late Timestamp date;
  late List<FriendInfo> people;
  late List<Photo> photos;
  late String id;

  Post({
    required this.content,
    required this.date,
    required this.people,
    required this.photos,
    required this.id,
  });

  Post.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    content = data['content'];
    date = data['date'];
    if (data['people'] != null) {
      people = List<FriendInfo>.empty(growable: true);
      data['people'].forEach((person) {
        people.add(FriendInfo.fromSnapshot(person));
      });
    }
    if (data['photos'] != null) {
      photos = List<Photo>.empty(growable: true);
      data['photos'].forEach((photo) {
        photos.add(Photo.fromSnapshot(photo));
      });
    }
  }

  Map<String, dynamic> toSnapshot() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['date'] = date;
    data['people'] = people.map((person) => person.toSnapshot()).toList();
    data['photos'] = photos.map((photo) => photo.toSnapshot()).toList();
    return data;
  }
}
