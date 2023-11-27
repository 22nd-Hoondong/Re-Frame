import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<XFile?> imageList = List<XFile?>.filled(5, null);
  final ImagePicker picker = ImagePicker();
  int selected = 0;

  DateTime date = DateTime.now();
  String _dropvalue = '';
  final _droplist = ['친구1', '친구2'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _dropvalue = _droplist[0];
    });
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
              const TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Input your text'),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Choose your friend',
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: _dropvalue,
                  items: _droplist
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _dropvalue = value!;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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
