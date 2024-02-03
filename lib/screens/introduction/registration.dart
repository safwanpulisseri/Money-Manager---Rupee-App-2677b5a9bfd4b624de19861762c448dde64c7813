import 'dart:developer';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/main_home.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final TextEditingController _userNameController = TextEditingController();

  File? _image;

  Future<String?> saveImage(File image) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = "${appDocDir.path}/$uniqueFileName.jpg";
      await image.copy(imagePath);
      return imagePath;
    } catch (e) {
      log("Error saving image: $e");
      return null;
    }
  }

  CountryCode? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.red, Colors.orange],
              ),
            ),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Login_logo.png',
                      height: 100,
                      width: 100,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Please finish to continue and get the',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'best from our app',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Container(
                    height: 570,
                    width: double.infinity,
                    color: Colors.white,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
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
                            child: Column(
                              children: [
                                _image != null
                                    ? Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 5,
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(5, 5),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 5,
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(5, 5),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.asset(
                                            'assets/profile.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                const Text('Add your photo'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              controller: _userNameController,
                              style: const TextStyle(
                                  fontSize: 20), // Adjust the text size
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: CountryCodePicker(
                                onChanged: (CountryCode countryCode) {
                                  _selectedCountry = countryCode;
                                },
                                initialSelection:
                                    'IN', // Initial selected country code
                                favorite: const [
                                  '+91',
                                  'US'
                                ], // Optional. To show only specific countries
                                showCountryOnly:
                                    true, // Set to true to only show country names without flags
                                showFlagMain:
                                    true, // Set to false to hide the main flag
                                showFlagDialog:
                                    true, // Set to false to hide the flag dialog
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

                                // List of countries to display
                                builder: (CountryCode? countryCode) {
                                  return Row(children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Image.asset(countryCode!.flagUri!,
                                        package: 'country_code_picker'),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      countryCode.name!,
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  ]);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  final name = _userNameController.text.trim();
                                }
                                String? imagePath = _image?.path;
                                if (_image != null) {
                                  imagePath = await saveImage(_image!);
                                  if (imagePath == null) {
                                  } else {}
                                }
                                if (_userNameController.text.isNotEmpty) {
                                  final String selectedCountryCode =
                                      _selectedCountry?.code ??
                                          'IN'; // Default value IN
                                  {
                                    final String user = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    final UserModel details = UserModel(
                                        id: user,
                                        imagePath: _image != null
                                            ? _image!.path
                                            : null, // Add image path if available
                                        name: _userNameController.text,
                                        country:
                                            selectedCountryCode // Store the selected country code
                                        );

                                    await UserProfileFunctions()
                                        .addProfileDetails(details);

                                    // print(
                                    //     'key=${details.id}  Name=${details.name} image= ${details.imagePath} country= ${details.country}');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Welcome to Rupee App',
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: incomeColor,
                                        duration: Duration(seconds: 3),
                                        margin: EdgeInsets.all(10),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ScreenMainHome(),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Something Error',
                                        textAlign: TextAlign.center,
                                      ),
                                      backgroundColor: expenseColor,
                                      duration: Duration(seconds: 2),
                                      margin: EdgeInsets.all(10),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
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
                                  'Finish',
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
