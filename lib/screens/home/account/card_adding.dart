import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rupee_app/database/card_controller.dart';
import 'package:rupee_app/model/db_cards.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/account/cards_added.dart';

class ScreenAddingCards extends StatefulWidget {
  const ScreenAddingCards({super.key});

  @override
  State<ScreenAddingCards> createState() => _ScreenAddingCardsState();
}

class _ScreenAddingCardsState extends State<ScreenAddingCards> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderController = TextEditingController();
  TextEditingController validThruController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _validateCardNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please enter card number';
    }
    // Implement further validation logic if needed
    return null;
  }

  String? _validateValidThru(String? value) {
    if (value!.isEmpty) {
      return 'Please enter valid thru';
    }
    return null;
  }

  String? _validateCardHolder(String? value) {
    if (value!.isEmpty) {
      return 'Please enter card holder name';
    }
    return null;
  }

  void _addCardToDatabase() async {
    if (_formKey.currentState!.validate()) {
      String cardHolder = cardHolderController.text;
      String cardNumber = cardNumberController.text;
      String validThru = validThruController.text;

      // Create a CardModel object
      CardModel newCard = CardModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardNumber: cardNumber,
        cardValid: validThru,
        cardHolder: cardHolder,
      );
      await CardModelFunctions().addCard(newCard);
      // Show snackbar after successfully adding the card
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Card added successfully',
            textAlign: TextAlign.center,
          ),
          backgroundColor: incomeColor,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior
              .floating, // Add space between Snackbar and BottomNavigationBar
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScreenAddedCards()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            'New Card',
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: cardNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(19),
                            CardNumberInputFormatter(),
                          ],
                          validator: _validateCardNumber,
                          decoration: InputDecoration(
                            hintText: 'Card Number',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SvgPicture.asset('assets/credit_card.svg'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: validThruController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            ValidThruInputFormatter(),
                          ],
                          validator: _validateValidThru,
                          decoration: InputDecoration(
                            hintText: 'Valid Thru',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SvgPicture.asset('assets/calendar.svg'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: cardHolderController,
                          keyboardType: TextInputType.name,
                          validator: _validateCardHolder,
                          decoration: InputDecoration(
                            hintText: 'Card Holder',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SvgPicture.asset('assets/user.svg'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: GestureDetector(
                          onTap: () {
                            _addCardToDatabase();
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Add',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ValidThruInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text.replaceAll("/", "");
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      if (i == 1 && inputData.length > 2) {
        buffer.write("/");
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 4 == 0 && inputData.length != index) {
        buffer.write(" ");
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.toString().length,
      ),
    );
  }
}
