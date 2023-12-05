import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:re_frame/Pages/calendar.dart';
import 'package:re_frame/Pages/gallery.dart';
import 'package:re_frame/Pages/friends.dart';
import 'package:re_frame/Pages/login.dart';
import 'package:re_frame/Widgets/fluid_navbar.dart';
import 'package:re_frame/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Color defaultColor = const Color(0xffFFC1B4);

class AppBarParams {
  Widget title;
  List<Widget> actions;
  Color backgroundColor;

  AppBarParams()
      : title = const Text(''),
        actions = [],
        backgroundColor = defaultColor;

  AppBarParams.setValue(this.title, this.actions, this.backgroundColor);
}

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
    key,
    this.initialPage = 0,
  }) : super(key: key);

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
      appBar: AppBar(
        title: _params.title,
        actions: _params.actions,
        backgroundColor: _params.backgroundColor,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // No sliding
        children: [
          Gallery(key: _pageKeys[0]),
          Calendar(key: _pageKeys[1]),
          const Text("easter eggs"),
          Friends(key: _pageKeys[3]),
          Login(key: _pageKeys[4]),
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
        pageController: _pageController,
        defaultColor: defaultColor,
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
    print('changed $_page');
    print(_pageKeys[_page].currentState);
    _pageKeys[_page].currentState?.onPageVisible();
  }
}

mixin MyHomePageStateMixin<T extends StatefulWidget> on State<T> {
  void onPageVisible();
}
