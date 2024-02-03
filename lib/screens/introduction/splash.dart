import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/home/main_home.dart';
import 'package:rupee_app/screens/introduction/intro.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      checkUserDetails(context); // Call the function to check user details
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Login_logo.png',
                  width: 220,
                  height: 220,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rupee App',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void checkUserDetails(BuildContext context) {
    final UserProfileFunctions profileFunctions = UserProfileFunctions();
    final List<UserModel> profileDetailsList =
        profileFunctions.getAllProfileDetails();

    if (profileDetailsList.isNotEmpty) {
      final UserModel profileDetails = profileDetailsList.first;

      if (profileDetails.name != null && profileDetails.name!.isNotEmpty) {
        // If user name exists, navigate directly to ScreenHome
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenMainHome()),
        );
      } else {
        // If user name does not exist, navigate to ScreenIntro
        navigateToIntro(context);
      }
    } else {
      // If no user details exist, navigate to ScreenIntro
      navigateToIntro(context);
    }
  }

  void navigateToIntro(BuildContext context) {
    // Navigate to the introduction screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ScreenIntro()),
    );
  }
}
