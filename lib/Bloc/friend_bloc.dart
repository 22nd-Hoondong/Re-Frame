import 'dart:async';

import 'package:flutter/foundation.dart';

import '../Models/friend_model.dart';
import '../Repository/friend_repository.dart';

class FriendBloc {
  final _streamController = StreamController<List<FriendInfo>>.broadcast();
  Stream<List<FriendInfo>> get stream =>
      _streamController.stream.asBroadcastStream();

  final repository = FriendRepository();

  void dispose() {
    _streamController.close();
  }

  void getFriends() async {
    var result = await repository.getFriends();
    var friends = result.map((e) => FriendInfo.fromJson(e)).toList();
    _streamController.sink.add(friends);
  }

  void searchFriends(String searchText) async {
    if (searchText.isEmpty) {
      _streamController.sink.add(List.empty());
      return;
    }

    var oldFriends = (await repository.getFriends())
        .map((e) => FriendInfo.fromJson(e))
        .toList();
    for (var element in oldFriends) {
      if (kDebugMode) {
        print(element.name);
      }
    }

    var newFriends = (await repository.searchFriends(searchText))
        .map((e) => FriendInfo.fromJson(e))
        .toList();
    for (var element in newFriends) {
      if (kDebugMode) {
        print(element.name);
      }
    }

    var result =
        newFriends.where((element) => !oldFriends.contains(element)).toList();
    for (var element in result) {
      if (kDebugMode) {
        print(element.name);
      }
    }

    result.removeWhere((element) => element.uid == repository.uid);

    _streamController.sink.add(result);
  }

  void addFriend(FriendInfo friend) async {
    await repository.addFriend(friend.toSnapshot());
  }

  void removeFriend(FriendInfo friend) async {
    await repository.removeFriend(friend.toSnapshot());
  }
}
