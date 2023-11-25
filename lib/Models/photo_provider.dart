import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:re_frame/Models/photo_model.dart';

class PhotoProvider with ChangeNotifier {
  late CollectionReference photoReference;
  List<Photo> photos = [];
  
  PhotoProvider({reference}) {
    photoReference = reference ?? FirebaseFirestore.instance.collection('photos');
  }

  Future<void> fetchPhotos() async {
    //photos = await photoReference.get().then
  }
}