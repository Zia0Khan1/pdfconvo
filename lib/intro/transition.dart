import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdfconvo/first_page.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 6),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Firstpage())));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    print("Screen Height : ${height}");
    print("Screen Width : ${width}");
    const colorizeColors = [
      Colors.blue,
      Colors.white,
      Colors.blue,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 40.0,
      fontFamily: 'Horizon',
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Spacer(),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Lottie.asset(
                  "assets/animations/lightsplash.json",
                ),
              ),
            ),
            DefaultTextStyle(
              softWrap: true,
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Horizon',
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                pause: Duration(milliseconds: 200),
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Images to PDF',
                    textStyle: colorizeTextStyle,
                    // speed: Duration(milliseconds: 200) ,
                    colors: colorizeColors,
                    // speed: Duration(milliseconds: 300)
                  ),
                  ColorizeAnimatedText(
                    'Share or Save',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                    // speed: Duration(milliseconds: 200)
                  ),
                ],

              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
