import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/database/card_controller.dart';
import 'package:rupee_app/model/db_cards.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/account/card_adding.dart';

class ScreenEditCard extends StatefulWidget {
  final String cardId;
  const ScreenEditCard({super.key, required this.cardId});

  @override
  State<ScreenEditCard> createState() => _ScreenEditCardState();
}

class _ScreenEditCardState extends State<ScreenEditCard> {
  CardModel? card;
  TextEditingController cardHolderUpdateController = TextEditingController();
  TextEditingController cardNumberUpdateController = TextEditingController();
  TextEditingController cardValidUpdateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchCardDetails();
  }

  Future<void> fetchCardDetails() async {
    final box = await Hive.openBox<CardModel>('cardBox');
    setState(() {
      card = box.get(widget.cardId);
      cardHolderUpdateController.text = card?.cardHolder ?? '';
      cardNumberUpdateController.text = card?.cardNumber ?? '';
      cardValidUpdateController.text = card?.cardValid ?? '';
    });
  }

  @override
  void dispose() {
    cardHolderUpdateController.dispose();
    cardNumberUpdateController.dispose();
    cardValidUpdateController.dispose();
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
          title: const Text('Edit Card Details'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  children: [
                    Form(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: cardNumberUpdateController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                                CardNumberInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Card Number',
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: SvgPicture.asset(
                                      'assets/credit-card.svg'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: cardValidUpdateController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                ValidThruInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Valid Thru',
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child:
                                      SvgPicture.asset('assets/calendar.svg'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: cardHolderUpdateController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: 'Card Holder',
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: SvgPicture.asset('assets/user.svg'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: GestureDetector(
                              onTap: () async {
                                if (card != null) {
                                  final updatedCard = CardModel(
                                      id: card!.id,
                                      cardNumber:
                                          cardNumberUpdateController.text,
                                      cardValid: cardValidUpdateController.text,
                                      cardHolder:
                                          cardHolderUpdateController.text);
                                  await CardModelFunctions()
                                      .updateCard(card!.id, updatedCard);

                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          backgroundColor: incomeColor,
                                          duration: Duration(seconds: 2),
                                          margin: EdgeInsets.all(10),
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            'Card Updated',
                                            textAlign: TextAlign.center,
                                          )));
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
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
