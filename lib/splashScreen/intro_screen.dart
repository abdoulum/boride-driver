import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/svg.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Register',
      finishButtonTextStyle: TextStyle(fontFamily: "Brand-Bold", fontSize: 20),
      onFinish: () {
        Navigator.pop(context);
      },
      finishButtonColor: Colors.indigo,
      skipTextButton: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          fontFamily: "Brand-regular",
          color: Colors.indigo,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          fontFamily: "Brand-regular",
          color: Colors.indigo,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.pop(context);
      },
      controllerColor: Colors.indigo,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        SvgPicture.asset(
          'images/undraw_welcome_re_h3d9.svg',
          height: 400,
        ),
        SvgPicture.asset(
          'images/undraw_upload_re_pasx.svg',
          height: 350,
        ),
        SvgPicture.asset(
          'images/undraw_accept_terms_re_lj38.svg',
          height: 350,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.indigo,
                  fontFamily: "Brand-bold",
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Navigate to the Registration page at the end to sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: "Brand-regular",
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'Provide Required Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.indigo,
                  fontFamily: "Brand-Bold",
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Enter Information And Upload necessary documents',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: "Brand-regular",
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'Done',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.indigo,
                  fontFamily: "Brand-Bold",
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'After you upload your document, wait for our confirmation email then log In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Brand-regular",
                  color: Colors.black45,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
