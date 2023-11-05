import 'package:flutter/material.dart';
import 'package:re_frame/Widgets/photo_modal.dart';

class ImageContainer extends StatelessWidget {
  final double width, height;
  const ImageContainer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PhotoModal()));
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: height,
            width: width,
            color: const Color(0xFFD9D9D9),
            child: const Text("text"),
          ),
          Positioned(
            bottom: height,
            left: width / 4,
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
