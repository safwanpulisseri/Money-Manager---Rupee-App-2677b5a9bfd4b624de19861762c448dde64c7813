import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rupee_app/screens/introduction/registration.dart';

class ScreenIntro extends StatelessWidget {
  const ScreenIntro({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.red,
                        Colors.orange
                      ], // Use parentheses instead of square brackets
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(200, 50),
                      bottomRight: Radius.elliptical(30, 30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Lottie.asset(
                          'assets/animations/Animation - 1701959152553.json',
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Let's",
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'manage',
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(children: [
                            Text(
                              'money ',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red),
                            ),
                          ]),
                          Text(
                            'with us',
                            style: TextStyle(fontSize: 30),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenLogin(),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Colors.red,
                          Colors.orangeAccent,
                          Colors.deepOrange,
                        ],
                        begin: Alignment(-1, -4),
                        end: Alignment(1, 4),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'halter',
                        fontSize: 14,
                        package: 'flutter_credit_card',
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

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    // Adding slope to the left side
    path.lineTo(0, h - 30); // Move slightly up
    path.lineTo(w, h);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
