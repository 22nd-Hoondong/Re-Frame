import 'package:flutter/material.dart';
import 'package:re_frame/Widgets/image_container.dart';
import 'package:re_frame/main.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery>
    with AutomaticKeepAliveClientMixin, MyHomePageStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

  @override
  void onPageVisible() {
    print('changed to gallery');
    MyHomePage.of(context)?.params = AppBarParams();
  }
}
