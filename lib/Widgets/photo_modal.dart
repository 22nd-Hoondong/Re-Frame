import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PhotoModal extends StatelessWidget {
  PhotoModal({super.key});

  final db = FirebaseFirestore.instance;

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
              print(snapshot.data!.docs);
              return Column(
                children: snapshot.data!.docs
                    .map((e) => Text("${e.data()}"))
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
