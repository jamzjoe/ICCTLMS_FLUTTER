import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({Key? key}) : super(key: key);

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntroductionScreen(
        animationDuration: 450,
        globalBackgroundColor: Colors.white,
        pagesAxis: Axis.horizontal,
        pages: [
          PageViewModel(
              title: 'Title 1',
              body: 'Description 1',
              decoration: getPageDecoration(),
              image: Hero(
                  tag:'intro',
                  child: buildImage('assets/i_developer.svg'))),
          PageViewModel(
              title: 'Title 2',
              body: 'Description 2',
              decoration: getPageDecoration(),
              image: Hero(
                  tag: 'intro',
                  child: buildImage('assets/i_online.svg'))),
          PageViewModel(
              title: 'Title 3',
              body: 'Description 3',
              decoration: getPageDecoration(),
              image: Hero(
                  tag: 'intro',
                  child: buildImage('assets/i_tuition.svg')))
        ],
        done: Hero(
          tag: 'joe',
          child: ElevatedButton.icon(
              onPressed: () {
                goToChooseUserType();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[900]
              ),
              icon: const Icon(CupertinoIcons.forward),
              label: const Text('Start')),
        ),
        onDone: () {},
        onSkip: () {},
        dotsDecorator: getDotDecoration(),
        skip: Hero(
          tag: 'joe',
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[900]
              ),
              onPressed: () {
                goToChooseUserType();
              },
              icon: const Icon(CupertinoIcons.fullscreen_exit),
              label: const Text('Skip')),
        ),
        showSkipButton: true,
        next: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget buildImage(String path) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: SvgPicture.asset(path, width: 200,),
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
        titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 15),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );

  void goToChooseUserType() {
    Navigator.pushNamedAndRemoveUntil(context, '/choose_user', (route) =>
    false);
  }
}
