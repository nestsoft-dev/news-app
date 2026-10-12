import 'package:flutter/material.dart';
import 'package:newapp/constants/appConstantFile.dart';
import 'package:newapp/models/onboardingModel.dart';
import 'package:newapp/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    print('Current Page: $_currentPage');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              //skip button
              Padding(
                padding: EdgeInsets.all(8.0).copyWith(right: size.width * .06),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text('Skip'),
                ),
              ),
              SizedBox(height: size.height * .02),

              //image, title, decription
              SizedBox(
                height: size.height * .65,
                width: size.width * .9,

                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    print('Current Page: $_currentPage');
                  },
                  controller: _pageController,
                  itemCount: onboardingData['onboarding']!.length,
                  itemBuilder: (_, index) {
                    final onboardingModel = OnboardingModel.fromJson(
                      onboardingData['onboarding']![index],
                    );

                    return OnboardingDesign(
                      size: size,
                      onboardingModel: onboardingModel,
                    );
                  },
                ),
              ),

              SizedBox(height: size.height * .02),

              //indicator
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: onboardingData['onboarding']!.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                  ),
                ),
              ),

              SizedBox(height: size.height * .02),
              GestureDetector(
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  if (_currentPage ==
                      onboardingData['onboarding']!.length - 1) {
                   

                    await prefs.setBool('completeOnboarding', true);

                    // Navigate to the next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Homepage()),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Container(
                  height: size.height * .06,
                  width: size.width * .9,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(size.height * .02),
                  ),
                  child: Center(
                    child: Text(
                      _currentPage == onboardingData['onboarding']!.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * .02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingDesign extends StatelessWidget {
  const new({super.key, required this.size, required this.onboardingModel});

  final Size size;
  final OnboardingModel onboardingModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: size.height * .5,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(onboardingModel.imageUrl ?? ''),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(size.height * .02),
          ),
        ),

        SizedBox(height: size.height * .02),
        Text(
          onboardingModel.title ?? '',
          style: TextStyle(
            fontSize: size.height * .03,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * .01),
        Text(
          onboardingModel.description ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size.height * .015,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
