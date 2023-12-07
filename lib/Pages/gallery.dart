import 'package:flutter/material.dart';
import 'package:re_frame/Widgets/image_container.dart';
import 'package:re_frame/main.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> with MyHomePageStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/cork_board.jpg"), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  3,
                  (index) => const ImageContainer(
                        height: 220,
                        width: 100,
                      )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  3,
                  (index) => const ImageContainer(
                        height: 220,
                        width: 100,
                      )),
            )
          ],
        ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onPageVisible();
    });
  }

  @override
  void onPageVisible() {
    MyHomePage.of(context)?.params = AppBarParams();
  }
}
