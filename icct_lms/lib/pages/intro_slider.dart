import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({Key? key}) : super(key: key);

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: 'Gusto mo ng murang tuition?',
            body: 'Pero',
            decoration: getPageDecoration(),
            image: buildImage('assets/logo_black_text.png')),
        PageViewModel(
            title: 'Wala kang matutunan?',
            body: 'Tara na sa ICCT',
            decoration: getPageDecoration(),
            image: buildImage('assets/logo_black_text.png'))
      ],
      done: Hero(
        tag: 'joe',
        child: ElevatedButton.icon(
            onPressed: () {
              goToChooseUserType();
            },
            icon: const Icon(CupertinoIcons.forward),
            label: const Text('Start')),
      ),
      onDone: () {},
      onSkip: () {},
      dotsDecorator: getDotDecoration(),
      skip: Hero(
        tag: 'joe',
        child: ElevatedButton.icon(
            onPressed: () {
              goToChooseUserType();
            },
            icon: const Icon(CupertinoIcons.forward),
            label: const Text('Skip')),
      ),
      showSkipButton: true,
      skipOrBackFlex: 1,
      next: const Icon(Icons.arrow_forward),
    );
  }

  Widget buildImage(String path) => Center(
        child: Image.asset(
          path,
          width: 350,
        ),
      );

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: const Color(0xFFBDBDBD),
        //activeColor: Colors.orange,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );
  PageDecoration getPageDecoration() => const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );

  void goToChooseUserType() {
    Navigator.pushNamedAndRemoveUntil(context, '/choose_user', (route) =>
    false);
  }
}
