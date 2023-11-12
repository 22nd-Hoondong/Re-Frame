import 'package:flutter/material.dart';
import 'package:re_frame/calendar_util.dart';

class PostModal extends StatelessWidget {
  final Post _post;
  const PostModal({super.key, required Post post}) : _post = post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: <Widget>[
          Text(_post.title),
          const SizedBox(
            height: 10,
          ),
          Text(_post.content),
          const SizedBox(
            height: 10,
          ),
          Text("${_post.date}"),
          const SizedBox(
            height: 10,
          ),
          Text("${_post.people}"),
          const SizedBox(
            height: 10,
          ),
          Text("${_post.photos}"),
        ],
      ),
    );
  }
}
