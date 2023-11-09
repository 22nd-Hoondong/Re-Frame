import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PhotoModal extends StatelessWidget {
  PhotoModal({super.key});

  final db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();
  List<Image> imageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: FutureBuilder(
          future: db.collection("photos").get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 3,
                children: snapshot.data!.docs
                    .map((element) => FutureBuilder(
                          future: storageRef
                              .child("${element.id}.png")
                              .getData(10000 * 10000),
                          builder: (context, snapshots) {
                            if (snapshots.hasData) {
                              imageList.add(Image.memory(
                                snapshots.data!,
                                width: 150,
                                height: 150,
                              ));
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      context,
                                      Image.memory(
                                        snapshots.data!,
                                        width: 150,
                                        height: 150,
                                      ));
                                },
                                child: Image.memory(
                                  snapshots.data!,
                                  width: 150,
                                  height: 150,
                                ),
                              );
                            }
                            return const SizedBox(
                              height: 30,
                              width: 30,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        ))
                    .toList(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
