import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:re_frame/Pages/calendar.dart';
import 'package:re_frame/Pages/gallery.dart';
import 'package:re_frame/Pages/login.dart';
import 'package:re_frame/Widgets/fluid_navbar.dart';
import 'package:re_frame/firebase_options.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Color defaultColor = const Color(0xffFFC1B4);
final PageController pageController = PageController(initialPage: 0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        physics: const NeverScrollableScrollPhysics(), // No sliding
        children: const [
          Gallery(),
          Calendar(),
          Text("easter eggs"),
          Text("hello3"),
          Login(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.edit,
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
