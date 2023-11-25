import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_frame/Widgets/photopage.dart';
import 'package:re_frame/calendar_util.dart';

class PostModal extends StatelessWidget {
  final Post _post;
  final PageController pageController = PageController();

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
                        child: PhotoPage(
                          photos: _post.photos,
                          pageController: pageController,
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
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _post.title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "수정 시간",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  DateFormat("HH:mm").format(_post.date),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1000,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                border: Border.all(style: BorderStyle.solid)),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _post.people.map((docRef) {
                                return FutureBuilder(
                                    future: docRef.get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        Map<String, dynamic> doc =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        return Text(
                                          doc["name"],
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        );
                                      }
                                      return const CircularProgressIndicator();
                                    });
                              }).toList(),
                            ),
                          ),
                          Text(_post.content),
                          const SizedBox(
                            height: 500,
                          ),
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
