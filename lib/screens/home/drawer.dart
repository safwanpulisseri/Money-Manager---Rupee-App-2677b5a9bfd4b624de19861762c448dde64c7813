import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/add_category/new_category.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/account/about_us.dart';
import 'package:rupee_app/screens/home/account/cards_added.dart';
import 'package:rupee_app/screens/home/account/how_to_use.dart';
import 'package:rupee_app/screens/home/account/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Future<void> launchPrivacyPolicy() async {
    final Uri url = Uri.parse(
        'https://www.termsfeed.com/live/8a6630b6-fbd7-4bd9-8c63-bd8fa04778f9');

    try {
      await launchUrl(url);
    } catch (e) {
      print('Error launching URL: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        ValueListenableBuilder<Box<UserModel>>(
                          valueListenable: Hive.box<UserModel>('userProfileBox')
                              .listenable(),
                          builder: (context, box, child) {
                            final UserProfileFunctions profileFunctions =
                                UserProfileFunctions();
                            final List<UserModel> profileDetailsList =
                                profileFunctions.getAllProfileDetails();

                            if (profileDetailsList.isNotEmpty) {
                              final UserModel profileDetails =
                                  profileDetailsList.first;
                              // Check if the user has added a photo
                              if (profileDetails.imagePath != null &&
                                  profileDetails.imagePath!.isNotEmpty) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ScreenEditProfile(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 3.5,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        File(profileDetails.imagePath!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            // Default image if no photo is added
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ScreenEditProfile(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 3.5,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/profile.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder<Box<UserModel>>(
                          valueListenable: Hive.box<UserModel>('userProfileBox')
                              .listenable(),
                          builder: (context, box, child) {
                            final UserProfileFunctions profileFunctions =
                                UserProfileFunctions();
                            final List<UserModel> profileDetailsList =
                                profileFunctions.getAllProfileDetails();

                            if (profileDetailsList.isNotEmpty) {
                              final UserModel profileDetails =
                                  profileDetailsList.first;
                              // Check if the user's name is not null or empty
                              if (profileDetails.name != null &&
                                  profileDetails.name!.isNotEmpty) {
                                return Row(
                                  children: [
                                    Text(
                                      profileDetails.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  ],
                                );
                              }
                            }
                            // Default text if no name is added
                            return const Text(
                              'User',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            );
                          },
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenEditProfile()));
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 25,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScreenCategory()));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.red, Colors.orange]),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.category_rounded,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Category',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScreenAddedCards()));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.red, Colors.orange]),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.credit_card,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Cards',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ), //
                // const SizedBox(
                //   height: 10,
                // ),
                // TextButton(
                //   onPressed: () {
                //     final RenderBox box =
                //         context.findRenderObject() as RenderBox;
                //     Share.share(
                //       'Check out this amazing app!', // Add custom message/link here
                //       subject: 'Share App', // Add subject if needed
                //       sharePositionOrigin:
                //           box.localToGlobal(Offset.zero) & box.size,
                //     );
                //   },
                //   child: Row(
                //     children: [
                //       Container(
                //         height: 35,
                //         width: 35,
                //         decoration: BoxDecoration(
                //             gradient: const LinearGradient(
                //                 colors: [Colors.red, Colors.orange]),
                //             borderRadius: BorderRadius.circular(10)),
                //         child: const Icon(
                //           Icons.share,
                //           size: 25,
                //           color: Colors.black,
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 20,
                //       ),
                //       const Text(
                //         'Share app',
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontSize: 22,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScreenHowToUse()));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.red, Colors.orange]),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.question_mark,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'How to use',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                TextButton(
                  onPressed: () async {
                    launchPrivacyPolicy();
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.red, Colors.orange]),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.privacy_tip_outlined,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScreenAboutUs()));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.red, Colors.orange]),
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(
                          'assets/Login_logo.png',
                          height: 25,
                          width: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'About us',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.red, Colors.orange]),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.delete_forever,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Clear All',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          // title: const Text('Delete All Transactions'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      'Do you want to ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'delete all transactions?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: expenseColor),
                  ),
                  onPressed: () async {
                    try {
                      await TransactionModelFunctions()
                          .box
                          .clear(); // Clear transactions
                      transactionModelNotifier.value = []; // Clear notifier
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: expenseColor,
                          duration: Duration(seconds: 2),
                          margin: EdgeInsets.all(10),
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'All transactions deleted successfully!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } catch (error) {
                      // Handle any errors here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: expenseColor,
                          duration: Duration(seconds: 2),
                          margin: EdgeInsets.all(10),
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Failed to delete transactions!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
