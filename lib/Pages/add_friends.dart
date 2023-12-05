import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:re_frame/main.dart';

import '../Bloc/friend_bloc.dart';
import '../Models/friend_model.dart';
import 'friends.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({super.key});

  static final FriendBloc bloc = FriendBloc();

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColor,
        title: const Text('친구 추가'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchAnchor(
              isFullScreen: false,
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onChanged: (_) {
                    setState(() {
                      _searchText = controller.text;
                      AddFriends.bloc.searchFriends(_searchText);
                    });
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return List.empty();
              }),
        ),
        Expanded(
            child: StreamBuilder(
          stream: AddFriends.bloc.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (_searchText.isEmpty) {
              return const Center(child: Text('검색어를 입력해주세요'));
            } else if (snapshot.hasData) {
              var result = snapshot.data as List<FriendInfo>;
              return ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(result[index].name),
                      subtitle: Text(result[index].email),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          AddFriends.bloc.addFriend(result[index]);
                          AddFriends.bloc.searchFriends(_searchText);
                          Friends.bloc.getFriends();
                        },
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )),
      ],
    ));
  }
}
