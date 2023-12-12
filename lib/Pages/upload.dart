import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_frame/Bloc/friend_bloc.dart';
import 'package:re_frame/Models/friend_model.dart';
import 'package:re_frame/main.dart';

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
  final _titleEditController = TextEditingController();
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
          title: const Text('사진 / 글 작성'),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  pointColor,
                  backgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleEditController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: '제목'),
              ),
              const SizedBox(
                height: 20,
              ),
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
                    return imageList[index] == null
                        ? Container(
                            color: Colors.grey,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          )
                        : GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
                                builder: (context) => AlertDialog(
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    "사진을 삭제하시겠습니까?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  actions: [
                                    SizedBox(
                                      width: 100,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            selected--;
                                            imageList[index] = null;
                                            for (var x = index; x < 4; x++) {
                                              var temp = imageList[x];
                                              imageList[x] = imageList[x + 1];
                                              imageList[x + 1] = temp;
                                            }
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "네",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "아니오",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Image.file(File(imageList[index]!.path)),
                          );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await getImage(ImageSource.camera, selected);
                        setState(() {
                          if (imageList[selected] != null) selected++;
                        });
                      },
                      child: Text(
                        '카메라',
                        style: TextStyle(color: darkBackgroundColor),
                      )),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await getImage(ImageSource.gallery, selected);
                        setState(() {
                          if (imageList[selected] != null) selected++;
                        });
                      },
                      child: Text(
                        '갤러리',
                        style: TextStyle(color: darkBackgroundColor),
                      )),
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
                    const Text('날짜'),
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
                      child: Text(
                        '${date.year}-${date.month}-${date.day}',
                        style: TextStyle(color: darkBackgroundColor),
                      ),
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
                    border: OutlineInputBorder(), labelText: '내용'),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: UploadScreen.bloc.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return TextButton(
                      child: Text(
                        '친구 추가',
                        style: TextStyle(color: darkBackgroundColor),
                      ),
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
                                          '친구 목록',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: friendList.length,
                                        itemBuilder:
                                            (BuildContext context, int idx) {
                                          return TextButton(
                                            child: Text(
                                              friendList[idx].name,
                                              style: TextStyle(
                                                  color: darkBackgroundColor),
                                            ),
                                            onPressed: () {
                                              if (!addFriendList
                                                  .contains(friendList[idx])) {
                                                setState(() {
                                                  addFriendList
                                                      .add(friendList[idx]);
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
                              });
                        } else {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 90,
                                  color: const Color(0xffFFC1B4),
                                  child: const Center(
                                    child: Text(
                                      '친구가 없습니다!',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                    );
                  }),
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
                  onPressed: () async {
                    if (selected == 0 || _titleEditController.text == '') {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Text(
                                  '제목과 사진은 필수입니다!',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              actions: [
                                Center(
                                  child: TextButton(
                                    child: const Text('알겠습니다.'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            );
                          });
                    } else {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      List nowImages = [];
                      List people = List.generate(addFriendList.length,
                          (index) => addFriendList[index].uid);
                      people.add(currentUser!.uid);
                      var nowPost = await FirebaseFirestore.instance
                          .collection('posts')
                          .add({
                        'title': _titleEditController.text,
                        'date': date,
                        'people': people,
                        'content': _contentEditController.text,
                      });
                      for (var x in people) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(x)
                            .collection('posts')
                            .doc(nowPost.id)
                            .set({'id': nowPost.id});
                      }
                      for (var x = 0; x < 5; x++) {
                        if (imageList[x] != null) {
                          var nowImage = await FirebaseFirestore.instance
                              .collection('photos')
                              .add({
                            'colSize': 1,
                            'rowSize': 1,
                            'post': nowPost.id,
                          });
                          nowImages.add(nowImage.id);
                          FirebaseStorage.instance
                              .ref('${nowImage.id}.png')
                              .putFile(File(imageList[x]!.path));
                        }
                      }
                      nowPost.update({
                        'photos': nowImages,
                      });
                      if (!mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    '업로드',
                    style: TextStyle(color: darkBackgroundColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
