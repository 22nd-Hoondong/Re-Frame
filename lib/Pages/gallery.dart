import 'package:flutter/material.dart';
import 'package:re_frame/Widgets/image_container.dart';

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/cork_board.jpg"), fit: BoxFit.fill),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageContainer(
                  height: 200,
                  width: 100,
                ),
                ImageContainer(
                  height: 200,
                  width: 100,
                ),
                ImageContainer(
                  height: 200,
                  width: 100,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageContainer(
                  height: 200,
                  width: 100,
                ),
                ImageContainer(
                  height: 200,
                  width: 100,
                ),
                ImageContainer(
                  height: 200,
                  width: 100,
                ),
              ],
            )
          ],
        ));
  }
}
