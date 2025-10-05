import 'dart:async';
import 'package:flutter/material.dart';
import 'package:islam/screens/homePage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    // بعد 3 ثواني يروح للصفحة الرئيسية
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // عشان النص بالعربي
      child: Scaffold(
        backgroundColor: const Color(0xffEDEDED), 
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Image.asset(
                      "assets/1111111.png",
                      height: 300,
                    ),
                
                   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
