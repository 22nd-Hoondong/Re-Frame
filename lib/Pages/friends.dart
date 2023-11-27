import 'package:flutter/material.dart';

import 'package:re_frame/Bloc/friend_bloc.dart';
import 'package:re_frame/main.dart';

import '../Models/friend_model.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  static final FriendBloc bloc = FriendBloc();

  @override
  State createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with MyHomePageStateMixin {
  String _searchText = '';
  List<FriendInfo> _friends = [];

  @override
  void initState() {
    super.initState();

    Friends.bloc.getFriends();

    Friends.bloc.stream.listen((event) {
      setState(() {
        _friends = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          stream: Friends.bloc.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: _friends.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _friends[index].name.contains(_searchText)
                        ? ListTile(
                            title: Text(_friends[index].name),
                            onTap: () {},
                            trailing: const Icon(Icons.arrow_forward_ios),
                          )
                        : const SizedBox();
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )),
      ],
    );
  }

  @override
  void onPageVisible() {
    MyHomePage.of(context)?.params =
        AppBarParams(title: const Text('친구 목록'), actions: [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {},
      )
    ]);
  }
}

