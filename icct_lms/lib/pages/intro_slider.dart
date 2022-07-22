
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({Key? key}) : super(key: key);

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}



class _IntroSliderState extends State<IntroSlider> {

  final pageController = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    // TODO: implement initState
    pageController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          onPageChanged: (index){
            setState(() {
              isLastPage = index == 2;
            });
          },
          controller: pageController,
          children: [
            Container(
              color: Colors.blue[900],
              child: buildPage('assets/identity.json', 'Choose Your '
                  'Identity', 'Serves as an open channel of communication '
                  'between teachers, students, parents, and staff.'),
            ),
            Container(
              color: Colors.blue[900],
              child: buildPage('assets/create.json', 'Create Account', "You'v"
                  "e entered all the required information and now may access "
                  "the system's online learning courses."),
            ),
            Container(
              color: Colors.blue[900],
              child: buildPage('assets/learn.json', 'Learn and Discover',
                  'This will become a unique source of knowledge in your '
                      'field and will help you improve your skills.')
            )
          ],
        ),
      ),
      bottomSheet: isLastPage ? Container(
        height: 80,
        color: Colors.white,
        child:  Center(
          child: SizedBox(
            height: 80,
            width: 1000,
            child: TextButton(
              onPressed: () async{

                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);
                if(!mounted){
                  return;
                }
                Navigator.pushNamedAndRemoveUntil(context, '/wrap',
                        (route) =>
                false);

              },
              child: Text(
                'Get Started', style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                  color: Colors.blue[900]
              ),
              ),
            ),
          ),
        ),
      ) :
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: (){
              pageController.jumpToPage(2);
            }, child: Text
              ('SKIP', style: TextStyle(
              color: Colors.blue[900]
            ),)),
            Center(
              child: SmoothPageIndicator(
                controller: pageController,
                effect: const ExpandingDotsEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  dotColor: Colors.blueGrey,
                  activeDotColor: Colors.blueAccent
                ),
                onDotClicked: (index) => pageController.jumpToPage(index),
                count: 3,
              ),
            ),
            TextButton(onPressed: (){
              pageController.nextPage(duration: Duration(seconds: 1), curve:
              Curves.easeInOut);
            }, child: Text('Next', style: TextStyle(
              color: Colors.blue[900]
            ),))
          ],
        ),
      ),
    );
  }

  Widget buildPage(String path, String title, String description)=> Center(
    child: Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(path, width: 250),
          const SizedBox(height: 10,),
          Text(title, style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20
          ),
          ),
          const SizedBox(height: 5,),
          Center(
            child: Text(description, style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 15,
              color: Colors.white
            ),
            textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    ),
  );
}
