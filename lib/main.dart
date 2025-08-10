import 'dart:async';
import 'package:flutter/material.dart';
import 'package:no_music/pages/home.dart';
import 'package:no_music/pages/library.dart';
import 'package:no_music/pages/settings.dart';
import 'package:no_music/services/settings_service.dart';
import 'dart:math';

import 'package:progressive_blur/progressive_blur.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(surface: Colors.black),
        brightness: Brightness.dark,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(const Color.fromARGB(121, 57, 57, 57)),
            backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(28, 28, 28, 1)),
          )
        ),
        switchTheme: SwitchThemeData(
          overlayColor: WidgetStateProperty.all(const Color.fromARGB(121, 57, 57, 57)),
          trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Color.fromRGBO(72, 72, 72, 1);
          }),
          thumbColor: WidgetStateProperty.all(const Color.fromRGBO(28, 28, 28, 1)),
          trackOutlineColor: WidgetStateProperty.all(const Color.fromARGB(0, 0, 0, 0)),
          padding: EdgeInsets.all(8)
        ),
        sliderTheme: SliderThemeData(
          year2023: false,
          activeTrackColor: Colors.white,
          inactiveTrackColor: const Color.fromRGBO(72, 72, 72, 1),
          thumbSize: const WidgetStatePropertyAll(Size(24, 24)),
          trackHeight: 32,
          thumbColor: const Color.fromRGBO(28, 28, 28, 1),
          overlayColor: const Color.fromARGB(121, 57, 57, 57),

          trackShape: RoundedRectSliderTrackShape()
        ),
        listTileTheme: ListTileThemeData(
          tileColor: const Color.fromRGBO(28, 28, 28, 1),
          enableFeedback: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        
      ),
      home: const NavBarPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, required this.title});
  final String title;

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  var currentDestination = 0;
  late final StreamSubscription<String> _settingsSub;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    LibraryPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _settingsSub = SettingsService().onChanged.listen((key) {
      if (key == 'progressiveBlur') {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _settingsSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black, blurRadius: 60, spreadRadius: 50, offset: Offset.fromDirection(pi*1.5, -130))]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(100),
              child: NavigationBar(
                backgroundColor: Color.fromRGBO(41, 41, 41, 1),
                height: 72,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                labelPadding: EdgeInsets.all(0),
                destinations: [
                  NavigationDestination(
                    icon: 
                    Icon(
                      Icons.album_outlined,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    label: '',
                    selectedIcon: Icon(
                      Icons.album_outlined,
                      color: Color.fromRGBO(215, 25, 33, 1)
                    ),
                  ),
                  NavigationDestination(
                    icon: 
                    Icon(
                      Icons.library_music_outlined,
                      color: Color.fromRGBO(255, 255, 255, 1)
                    ),
                    label: '',
                    selectedIcon: Icon(
                      Icons.library_music_outlined,
                      color: Color.fromRGBO(215, 25, 33, 1)
                    ),
                  ),
                  NavigationDestination(
                    icon: 
                    Icon(
                      Icons.settings_outlined,
                      color: Color.fromRGBO(255, 255, 255, 1)
                    ),
                    label: '',tueetu
                    selectedIcon: Icon(
                      Icons.settings_outlined,
                      color: Color.fromRGBO(215, 25, 33, 1)
                    ),
                  ),
                ],
                indicatorColor: Colors.transparent,
                onDestinationSelected: (destination) {
                  setState(() {
                    currentDestination = destination;
                  });
                  
                },
                selectedIndex: currentDestination,
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: (() {
          final enableBlur = SettingsService().getBool('progressiveBlur') ?? false;
          final page = _pages[currentDestination];
          if (!enableBlur) return page;
          return ProgressiveBlurWidget(
            linearGradientBlur: LinearGradientBlur(
              values: [1.0, 0.0],
              stops: [0.0, 0.3],
              start: Alignment.bottomCenter,
              end: Alignment.center,
            ),
            sigma: 32,
            child: page,
          );
        })(),
      ),
    );
  }
}
