import 'package:anterin_kc_pky/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 18),
        bodyPadding: EdgeInsets.all(16));
    return WillPopScope(
      onWillPop: () async => false,
      child: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        dotsFlex: 3,
        pages: [
          PageViewModel(
              title: 'Anterin',
              body: 'Mau dianterin kemana hari ini?',
              decoration: pageDecoration,
              image: SvgPicture.asset(
                'assets/navigation.svg',
                width: 200,
              )),
          PageViewModel(
              title: 'Driver',
              body: 'Tentukan tanggal dan jam serta cek ketersediaan driver.',
              decoration: pageDecoration,
              image: SvgPicture.asset(
                'assets/select.svg',
                width: 200,
              )),
          PageViewModel(
              title: 'Mobile',
              body: 'Nikmati kemudahan fitur dalam genggaman.',
              decoration: pageDecoration,
              image: SvgPicture.asset(
                'assets/mobile.svg',
                width: 200,
              ))
        ],
        onDone: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        showSkipButton: true,
        showDoneButton: true,
        showNextButton: true,
        showBackButton: false,
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Login'),
        dotsDecorator: const DotsDecorator(
            color: Colors.grey,
            size: Size(10, 10),
            activeSize: Size(22, 10),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)))),
      ),
    );
  }
}
