import 'package:flutter/material.dart';
import 'package:re_frame/calendar_util.dart';

class PostModal extends StatelessWidget {
  final Post _post;
  const PostModal({super.key, required Post post}) : _post = post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(children: [
            Container(
              color: Colors.red,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.chevron_left)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.star_border)),
                ],
              ),
            ),
          ]),
          SingleChildScrollView(
            child: Column(
              children: [
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
          ),
        ],
      ),
    );
  }
}
