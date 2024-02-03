import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:rupee_app/screens/add_category/main_adding.dart';
import 'package:rupee_app/screens/home/screen_home.dart';
import 'package:rupee_app/screens/home/screen_statistics.dart';

class ScreenMainHome extends StatefulWidget {
  const ScreenMainHome({Key? key}) : super(key: key);

  @override
  State<ScreenMainHome> createState() => _ScreenMainHomeState();
}

class _ScreenMainHomeState extends State<ScreenMainHome> {
  int _selectedIndex = 0;
  final pages = const [
    ScreenHome(), // SCREEN ONE
    ScreenStatistics(), // SCREEN TWO
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenMainAdding(),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: CurvedNavigationBar(
        //   index: val,
        //   animationDuration: const Duration(milliseconds: 200),
        //   backgroundColor: Colors.white,
        //   color: Colors.orange,
        //   items: const [
        //     CurvedNavigationBarItem(
        //         child: Icon(
        //           Icons.home,
        //         ),
        //         label: 'Home'),
        //     CurvedNavigationBarItem(
        //         child: Icon(
        //           Icons.bar_chart_rounded,
        //         ),
        //         label: 'Statistics'),
        //   ],
        //   onTap: (index) {
        //     setState(() {
        //       val = index;
        //     });
        //   },
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: Colors.orange,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bar_chart_rounded,
                color: Colors.black,
              ),
              label: 'Statistics',
            ),
          ],
        ),
      ),
    );
  }
}
