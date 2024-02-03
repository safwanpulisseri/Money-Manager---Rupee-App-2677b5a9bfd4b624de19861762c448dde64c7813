import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/main_home.dart';

class ScreenEditProfile extends StatefulWidget {
  const ScreenEditProfile({Key? key}) : super(key: key);

  @override
  State<ScreenEditProfile> createState() => _ScreenEditProfileState();
}

class _ScreenEditProfileState extends State<ScreenEditProfile> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();
  String _selectedCountryCode = 'IN'; // Default country code

  void _updateUserProfile() async {
    final profileFunctions = UserProfileFunctions();
    final List<UserModel> profileDetailsList =
        profileFunctions.getAllProfileDetails();

    if (profileDetailsList.isNotEmpty) {
      final UserModel profileDetails = profileDetailsList.first;

      String? imagePath = profileDetails.imagePath;

      if (_image != null) {
        imagePath = _image!.path;
      }

      final updatedUser = UserModel(
        id: profileDetails.id,
        imagePath: imagePath,
        name: _nameController.text,
        country: _selectedCountryCode,
      );

      await profileFunctions.updateUserDetails(updatedUser);
      setState(() {
        _nameController.text = updatedUser.name;
        _selectedCountryCode = updatedUser.country;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile Updated successfully',
            textAlign: TextAlign.center,
          ),
          backgroundColor: incomeColor,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenMainHome(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    final profileFunctions = UserProfileFunctions();
    final List<UserModel> profileDetailsList =
        profileFunctions.getAllProfileDetails();

    if (profileDetailsList.isNotEmpty) {
      final UserModel profileDetails = profileDetailsList.first;
      setState(() {
        _nameController.text = profileDetails.name ?? '';
        _selectedCountryCode = profileDetails.country ?? 'IN';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              )),
          title: const Text('Back'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ValueListenableBuilder<Box<UserModel>>(
                  valueListenable:
                      Hive.box<UserModel>('userProfileBox').listenable(),
                  builder: (context, box, child) {
                    final UserProfileFunctions profileFunctions =
                        UserProfileFunctions();
                    final List<UserModel> profileDetailsList =
                        profileFunctions.getAllProfileDetails();

                    if (profileDetailsList.isNotEmpty) {
                      final UserModel profileDetails = profileDetailsList.first;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    content: const Text(
                                      'Choose Image From ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              getImageFromGallery();
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.image,
                                              color: Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              getImageFromCamera();
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                },
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
                                child: _image != null
                                    ? Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                      )
                                    : profileDetails.imagePath != null &&
                                            profileDetails.imagePath!.isNotEmpty
                                        ? Image.file(
                                            File(profileDetails.imagePath!),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/profile.png',
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          const Text('Edit your photo'),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: TextFormField(
                                controller: _nameController,
                                style: const TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  hintText: 'Edit your name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                  width: 2,
                                ),
                              ),
                              child: CountryCodePicker(
                                onChanged: (CountryCode countryCode) {
                                  setState(() {
                                    _selectedCountryCode = countryCode.code!;
                                  });
                                },
                                initialSelection: _selectedCountryCode,
                                favorite: const ['+91', 'US'],
                                showCountryOnly: true,
                                showFlagMain: true,
                                showFlagDialog: true,
                                countryFilter: const [
                                  'US',
                                  'CN',
                                  'IN',
                                  'ID',
                                  'BR',
                                  'RU',
                                  'NG',
                                  'EG',
                                  'DE',
                                  'FR',
                                  'GB',
                                  'IT',
                                  'ES',
                                  'AE',
                                  'SA',
                                  'JP',
                                  'KR',
                                  'TH',
                                  'MY',
                                  'VN',
                                  'PH',
                                  'SG',
                                  'BD',
                                  'PK',
                                  'LK',
                                  'QA',
                                  'KW',
                                  'OM',
                                  'BH',
                                  'JO',
                                  'SE',
                                  'NL',
                                  'CH',
                                  'PL',
                                  'TR',
                                ],
                                builder: (CountryCode? countryCode) {
                                  return Row(
                                    children: [
                                      const SizedBox(width: 15),
                                      Image.asset(countryCode!.flagUri!,
                                          package: 'country_code_picker'),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        countryCode.name!,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: GestureDetector(
                              onTap: () async {
                                _updateUserProfile();
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Update',
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
                      );
                    }
                    // Default UI if no profile details found
                    return const Text('No profile details found!');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  Future<void> getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }
}
