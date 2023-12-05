import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_frame/Bloc/friend_bloc.dart';
import 'package:re_frame/Models/friend_model.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});
  static final FriendBloc bloc = FriendBloc();

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<XFile?> imageList = List<XFile?>.filled(5, null);
  final ImagePicker picker = ImagePicker();
  int selected = 0;
  DateTime date = DateTime.now();
  final _contentEditController = TextEditingController();
  List<FriendInfo> addFriendList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UploadScreen.bloc.getFriends();
  }

  Future getImage(ImageSource imageSource, int index) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        imageList[index] = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1 / 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return imageList[index] != null
                        ? Image.file(File(imageList[index]!.path))
                        : Container(
                            color: Colors.grey,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.camera, selected);
                        setState(() {
                          selected++;
                        });
                      },
                      child: const Text('Camera')),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.gallery, selected);
                        setState(() {
                          selected++;
                        });
                      },
                      child: const Text('Gallary')),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.black45, width: 1.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Choose date'),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now());
                        if (selectedDate != null) {
                          setState(() {
                            date = selectedDate;
                          });
                        }
                      },
                      child: Text('${date.year}-${date.month}-${date.day}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                controller: _contentEditController,
                maxLines: null,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Input your text'),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: UploadScreen.bloc.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return TextButton(
                    child: Text('Add Friend'),
                    onPressed: () {
                      if (snapshot.hasData) {
                        var friendList = snapshot.data as List<FriendInfo>;
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 90,
                                  color: const Color(0xffFFC1B4),
                                  child: const Center(
                                    child: Text(
                                      'Your friend list',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: friendList.length,
                                    itemBuilder: (BuildContext context, int idx) {
                                      return TextButton(
                                        child: Text(friendList[idx].name),
                                        onPressed: () {
                                          if (!addFriendList.contains(friendList[idx])) {
                                            setState(() {
                                              addFriendList.add(friendList[idx]);
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        );
                      }
                      else {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 90,
                              color: const Color(0xffFFC1B4),
                              child: const Center(
                                child: Text(
                                  'You have no Friend',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        );
                      }
                    },
                  );
                }
              ),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: addFriendList.length,
                  itemBuilder: (BuildContext context, int idx) {
                    return ElevatedButton(
                      child: Text(addFriendList[idx].name),
                      onPressed: () {
                        setState(() {
                          addFriendList.remove(addFriendList[idx]);
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                  },
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
