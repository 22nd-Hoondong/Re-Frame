import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: const Alignment(0, 1),
          child: ElevatedButton(
            onPressed: (){},
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                minimumSize: const Size(56, 56)
            ),
            child: const Icon(Icons.edit),
          ),
        ),
      ],
    );
  }
}
