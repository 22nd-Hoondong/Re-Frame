import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:re_frame/Widgets/photo_modal.dart';

// ignore: must_be_immutable
class ImageContainer extends StatefulWidget {
  final double width, height;

  const ImageContainer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        imageData = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => PhotoModal()));
        setState(() {});
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          imageData == null
              ? Container(
                  height: widget.height,
                  width: widget.width,
                  color: const Color(0xFFD9D9D9),
                  child: const Icon(Icons.add_a_photo_outlined),
                )
              : Image.memory(
                  imageData!,
                  height: widget.height,
                  width: widget.width,
                ),
          Positioned(
            bottom: widget.height,
            left: widget.width / 4,
            child: const Image(
              image: AssetImage("images/pin_transparent.png"),
              height: 50,
              width: 50,
            ),
          ),
        ],
      ),
    );
  }
}
