// import package area
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:saw/Page/RegisterPage.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:firebase_core/firebase_core.dart';
// end import package area

// import path folder area
import './Page/LoginPage.dart';
// end import path folder area

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBtcIBJsoEvWsIQK3QSGbJ2AvulH3OUsx8",
              appId: "1:786838796103:android:eb3aff78ac5d33ace17e62",
              messagingSenderId: "786838796103",
              projectId: "mocall-1040d",
              storageBucket: "mocall-1040d.appspot.com"))
      : await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    // ignore: deprecated_member_use
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoCall',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool loginloading = false;
  bool loginabsorbPointer = false;
  bool registerloading = false;
  bool registerabsorbPointer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Carousel(
              indicatorBarColor:
                  const Color.fromARGB(0, 0, 0, 0).withOpacity(0.0),
              autoScrollDuration: Duration(seconds: 2),
              animationPageDuration: Duration(milliseconds: 500),
              activateIndicatorColor: Color(0xFF1877F2),
              animationPageCurve: Curves.bounceInOut,
              indicatorBarHeight: 10,
              indicatorHeight: 20,
              indicatorWidth: 20,
              unActivatedIndicatorColor: Colors.grey,
              stopAtEnd: false,
              autoScroll: true,
              // widgets
              items: [
                Image.asset(
                  'images/assets/startedupdate.png', // Replace with your image path
                  height: 200.0,
                ),
                Image.asset(
                  'images/assets/locationupdate.png', // Replace with your image path
                  height: 200.0,
                ),
                Image.asset(
                  'images/assets/communityupdate.png', // Replace with your image path
                  height: 200.0,
                ),
              ],
            )),
            SizedBox(height: 32.0),
            const TextAnimator(
              'Welcome User\'s',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextAnimator(
              'This platform will provide a range of features, including a situational awareness dashboard, community reporting system, safety resources and tips, community engagement forums, and safety checklists and guides.',
              textAlign: TextAlign.center,
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              width: 280.0, // Adjust the width as per your requirement
              child: AbsorbPointer(
                absorbing: loginabsorbPointer,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loginloading = true;
                      loginabsorbPointer = true;
                      registerabsorbPointer = true;
                      Future.delayed(const Duration(seconds: 5), () {
                        setState(() {
                          loginloading = false;
                          loginabsorbPointer = false;
                          registerabsorbPointer = false;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Login()),
                              (route) => false);
                        });
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        204, 0, 0, 0), // Set the background color to black
                    foregroundColor:
                        Colors.white, // Set the text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Set the button shape to rectangular
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0), // Adjust the vertical padding
                  ),
                  child: loginloading == true
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white, size: 28.0)
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 280.0, // Adjust the width as per your requirement
              child: AbsorbPointer( 
                absorbing: registerabsorbPointer,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      registerloading = true;
                      registerabsorbPointer = true;
                      loginabsorbPointer = true;
                      Future.delayed(const Duration(seconds: 5), () {
                        setState(() {
                          registerloading = false;
                          registerabsorbPointer = false;
                          loginabsorbPointer = false;
                          Navigator.pushAndRemoveUntil(
                              context, 
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RegisterStepper()),
                              (route) => false);
                        });
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF1877F2), // Set the background color to black
                    foregroundColor:
                        Colors.white, // Set the text color to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Set the button shape to rectangular
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0), // Adjust the vertical padding
                  ),
                  child: registerloading == true
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white, size: 28.0)
                      : Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
