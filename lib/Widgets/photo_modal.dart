import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PhotoModal extends StatelessWidget {
  PhotoModal({super.key});

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Reference storageRef = FirebaseStorage.instance.ref();

  Future<Set<String>> getPhotoIdList() async {
    Set<String> idSet = {};
    final userPostCollectionRef = await db
        .collection("users/${_firebaseAuth.currentUser?.uid}/posts")
        .get();
    for (var element in userPostCollectionRef.docs) {
      final userDoc = await db.collection("posts").doc(element.id).get();
      Map<String, dynamic> userData = userDoc.data()!;
      for (var id in userData["photos"]) {
        idSet.add(id);
      }
    }
    return idSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: FutureBuilder(
          future: getPhotoIdList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 3,
                children: snapshot.data!.map(
                  (element) {
                    return FutureBuilder(
                      future: storageRef
                          .child("$element.png")
                          .getData(10000 * 10000),
                      builder: (context, snapshots) {
                        if (snapshots.hasData) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, snapshots.data);
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
                    );
                  },
                ).toList(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
