import 'package:flutter/material.dart';
import 'package:re_frame/Bloc/friend_bloc.dart';
import 'package:re_frame/Models/friend_model.dart';
import 'package:re_frame/Pages/add_friends.dart';
import 'package:re_frame/main.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  static final FriendBloc bloc = FriendBloc();

  @override
  State createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with MyHomePageStateMixin {
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    Friends.bloc.getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
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
                var result = snapshot.data as List<FriendInfo>;
                return ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (result[index].name.contains(_searchText) ||
                        result[index].email.contains(_searchText)) {
                      return Dismissible(
                        key: Key(result[index].uid),
                        onDismissed: (direction) {
                          Friends.bloc.removeFriend(result[index]);
                          setState(() {
                            result.removeAt(index);
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(result[index].name),
                          subtitle: Text(result[index].email),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onPageVisible();
    });
  }

  @override
  void onPageVisible() {
    MyHomePage.of(context)?.params = AppBarParams.setValue(
        const Text('친구 목록'),
        [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddFriends()));
            },
          )
        ],
        pointColor);
  }
}
