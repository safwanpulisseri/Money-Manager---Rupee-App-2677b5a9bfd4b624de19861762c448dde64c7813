import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenHowToUse extends StatelessWidget {
  const ScreenHowToUse({super.key});

  // Function to launch YouTube video
  Future<void> launchYouTubeVideo() async {
    final Uri url = Uri.parse('https://youtu.be/QJ0k49VmdMc');

    try {
      await launchUrl(url);
    } catch (e) {
      print('Error launching URL: $e');
      // Handle the error as needed
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
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.orange,
                ],
              ),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: const Text(
            'How to use',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  height: 20,
                ),
                const SizedBox(
                  width: 250,
                  child: Text(
                    "Here's a quick guide on how to use the app:Enjoy using the app and manage your finances. Please visit our YouTube channel or watch our video now :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchYouTubeVideo(); // Launch YouTube video on tap
                  },
                  child: const Text(
                    'Youtube video link', // Text to act as a link
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
