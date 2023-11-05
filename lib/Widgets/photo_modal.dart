import 'package:flutter/material.dart';

class PhotoModal extends StatelessWidget {
  const PhotoModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: GridView.count(crossAxisCount: 3));
  }
}
