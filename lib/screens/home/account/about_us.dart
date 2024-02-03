import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenAboutUs extends StatelessWidget {
  const ScreenAboutUs({super.key});
// Function to launch email on tap
  Future<void> launchEmail() async {
    const String emailAddress = 'safwanpulisseri123@gmain.com';
    const String emailSubject = 'Question/Feedback';
    const String emailBody = 'Your_feedback_here';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': emailSubject,
        'body': emailBody,
      },
    );
    try {
      await launchUrl(emailUri);
    } catch (e) {
      // Handle error
      print('Error launching email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              )),
          title: const Text(
            'About us',
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/Login_logo.png',
                  height: 70,
                  width: 70,
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      const Text(
                        'This is an app developed as a part of my project which is the biggest milestone in my career and it is a money management app which will be useful for many people who have bad spending habits. They can be on track of how to manage their money management. If you have any questions or feedback about the Rupee app, you can contact us at :',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchEmail(); // Launch email on tap
                  },
                  child: const Text(
                    'safwanpulisseri123@gmain.com', // Text to act as a link
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
