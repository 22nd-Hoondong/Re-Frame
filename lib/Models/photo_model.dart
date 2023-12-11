import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:re_frame/Models/post_model.dart';

class Photo {
  late int colSize;
  late int rowSize;
  late Post post;
  late String id;

  Photo(
      {required this.colSize,
      required this.rowSize,
      required this.post,
      required this.id});

  Photo.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    colSize = data['colSize'];
    rowSize = data['rowSize'];
    if (data['post'] != null) {
      post = Post.fromSnapshot(data['post']);
    }
  }

  Map<String, dynamic> toSnapshot() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['colSize'] = colSize;
    data['rowSize'] = rowSize;
    if (post != null) {
      data['post'] = post.toSnapshot();
    }
    return data;
  }
}
