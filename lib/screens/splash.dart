import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:heal_music/screens/bottum.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  @override
  void initState() {
    super.initState();
    next();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/SPLASH11111.png'),
            Image.asset(
              'lib/assets/1-CsJ05WEGfunYMLGfsT2sXA-unscreen.gif',
              width: 200.w,
            )
          ],
        ),
      ),
    );
  }

  next() {
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Bottum()));
    });
  }
}
