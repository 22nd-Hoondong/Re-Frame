import 'dart:async';

import 'package:re_frame/Pages/friends.dart';

import '../Repository/friend_repository.dart';

class FriendBloc {
  late List<FriendInfo> _friends = [];

  final _streamController = StreamController<List<FriendInfo>>.broadcast();
  Stream<List<FriendInfo>> get stream => _streamController.stream;

  final repository = FriendRepository();

  void dispose() {
    _streamController.close();
  }

  void getFriends() async {
    var result = await repository.getFriends();
    _friends = result.map((e) => FriendInfo.fromJson(e)).toList();
    _streamController.sink.add(_friends);
  }
}