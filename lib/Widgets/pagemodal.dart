import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:re_frame/calendar_util.dart';

class PostModal extends StatelessWidget {
  final Post _post;
  final Reference storageRef = FirebaseStorage.instance.ref();

  PostModal({super.key, required Post post}) : _post = post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 400,
                        child: PageView(
                          children: _post.photos.map((element) {
                            return FutureBuilder(
                                future: storageRef
                                    .child("$element.png")
                                    .getData(10000 * 10000),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.memory(
                                      snapshot.data!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                    );
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                });
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
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
                            height: 100,
                          ),
                          Text("${_post.photos}"),
                        ],
                      ),
                    ),
                  ],
                ),
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
          ],
        ),
      ),
    );
  }
}
