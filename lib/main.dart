import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:re_frame/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:re_frame/Pages/calendar.dart';
import 'package:re_frame/Pages/friends.dart';
import 'package:re_frame/Pages/gallery.dart';
import 'package:re_frame/Pages/login.dart';
import 'package:re_frame/Pages/upload.dart';
import 'package:re_frame/Pages/setting.dart';
import 'package:re_frame/Widgets/fluid_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Color pointColor = const Color(0xffffc5b6);
Color backgroundColor = const Color(0xFFFFFDFD);
Color darkBackgroundColor = const Color(0xFFFF7C5F);

class AppBarParams {
  Widget title;
  List<Widget> actions;
  Color backgroundColor;

  AppBarParams()
      : title = const Text(''),
        actions = [],
        backgroundColor = pointColor;

  AppBarParams.setValue(this.title, this.actions, this.backgroundColor);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: pointColor,
              primary: pointColor,
              background: backgroundColor,
              onPrimaryContainer: Colors.black),
          useMaterial3: true,
          fontFamily: 'GowunDodum',
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int initialPage;

  const MyHomePage({
    super.key,
    this.initialPage = 0,
  });

  @override
  State<StatefulWidget> createState() => MyHomePageState();

  static MyHomePageState? of(BuildContext context) {
    return context.findAncestorStateOfType<MyHomePageState>();
  }
}

class MyHomePageState extends State<MyHomePage> {
  final List<GlobalKey<MyHomePageStateMixin>> _pageKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  final PageController _pageController = PageController(initialPage: 0);
  AppBarParams _params = AppBarParams();
  int _page = 0;

  set params(AppBarParams value) {
    setState(() {
      _params = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageKeys[0].currentState?.onPageVisible();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page != 0 ? AppBar(
          title: _params.title,
          actions: _params.actions,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _params.backgroundColor,
                  backgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          )
      ) : null,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // No sliding
        children: [
          Gallery(key: _pageKeys[0]),
          Calendar(key: _pageKeys[1]),
          Text("easter eggs", key: _pageKeys[2]),
          Friends(key: _pageKeys[3]),
          Setting(key: _pageKeys[4]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UploadScreen()));
        },
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: FluidNavBar(
        pageController: _pageController,
        defaultColor: pointColor,
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    _onPageChanged(_page);
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
  }
}

mixin MyHomePageStateMixin<T extends StatefulWidget> on State<T> {
  void onPageVisible();
}
