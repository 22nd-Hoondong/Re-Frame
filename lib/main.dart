import 'package:flutter/material.dart';
import 'package:re_frame/Pages/gallery.dart';
import 'package:re_frame/Widgets/fluid_navbar.dart';

void main() {
  runApp(const MyApp());
}

Color defaultColor = const Color(0xffFFC1B4);
final PageController pageController = PageController(initialPage: 0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: defaultColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PageView(
        controller: pageController,
        children: const [
          Gallery(),
          Text("world2"),
          Text("hello3"),
          Text("world4"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.edit,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FluidNavBar(
        pageController: pageController,
        defaultColor: defaultColor,
      ),
    );
  }
}

