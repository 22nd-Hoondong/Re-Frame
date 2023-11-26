import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PhotoPage extends StatelessWidget {
  final List<dynamic> photos;
  final PageController pageController;
  final Reference storageRef = FirebaseStorage.instance.ref();
  PhotoPage({super.key, required this.photos, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: photos.map((element) {
        return FutureBuilder(
            future: storageRef.child("$element.png").getData(10000 * 10000),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                );
              }
              return const Center(child: CircularProgressIndicator());
            });
      }).toList(),
    );
  }
}
