import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  GreetingWidget({super.key});
  final DateTime currentTime = DateTime.now();
  String getGreeting() {
    final int hour = currentTime.hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getGreeting(),
    );
  }
}
