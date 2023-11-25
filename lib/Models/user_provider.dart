import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:re_frame/Models/user_model.dart';

class UserProvider with ChangeNotifier {
  late CollectionReference userReference;
  List<User> users = [];
}