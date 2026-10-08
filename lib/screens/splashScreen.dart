import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newapp/screens/onboarding/onboardingpage.dart';
import 'package:typewritertext/typewritertext.dart';

class Splashscreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {

    // nav
    Future.delayed(const Duration(seconds: 3), () {
      
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const OnboardingScreen())); 
    });
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Color.fromARGB(255, 12, 0, 71), Colors.blue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: TypeWriter.text(
            'Welcome to Newapp\n\nBy Shabaal',
            textAlign: TextAlign.center,
            duration: const Duration(milliseconds: 50),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: size.height * .03,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
