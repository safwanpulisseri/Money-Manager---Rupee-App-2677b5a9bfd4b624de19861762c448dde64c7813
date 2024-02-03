import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rupee_app/database/card_controller.dart';
import 'package:rupee_app/model/db_cards.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/account/card_adding.dart';
import 'package:rupee_app/screens/home/account/card_edit.dart';
import 'package:rupee_app/screens/home/main_home.dart';

class ScreenAddedCards extends StatefulWidget {
  const ScreenAddedCards({Key? key}) : super(key: key);

  @override
  State<ScreenAddedCards> createState() => _ScreenAddedCardsState();
}

class _ScreenAddedCardsState extends State<ScreenAddedCards> {
  @override
  void initState() {
    super.initState();
    CardModelFunctions().getAllCards();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenMainHome()));
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
          ),
          title: const Text('Added Cards'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScreenAddingCards()),
                );
              },
              icon: const Icon(
                Icons.add,
                size: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: ValueListenableBuilder<List<CardModel>>(
            valueListenable: cardModelNotifier,
            builder: (context, cardList, _) {
              final List<CardModel> reversedCards = cardList.reversed.toList();
              if (cardList.isEmpty) {
                return const Center(
                  child: Text(
                    'No Cards available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: reversedCards.length,
                itemBuilder: (context, index) {
                  final card = reversedCards[index];
                  return buildCardWidget(
                      card); // Custom method to build card widget
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildCardWidget(CardModel card) {
    int firstDigit = int.parse(card.cardNumber[0]);
    Color cardColor = Colors.black;

    String imagePath = '';
    if (firstDigit == 2) {
      // For Mastercard
      imagePath = 'assets/mastercard.png';
      cardColor = const Color.fromARGB(255, 192, 92, 21);
    } else if (firstDigit == 3) {
      // For other card types starting with 3
      imagePath = 'assets/Amercan_express-removebg-preview.png';
      cardColor = const Color.fromARGB(255, 3, 85, 152);
    } else if (firstDigit == 4) {
      // For other card types starting with 4
      imagePath = 'assets/VISA-removebg-preview.png';
      cardColor = const Color.fromARGB(255, 6, 26, 56);
    } else if (firstDigit == 5) {
      // For other card types starting with 5
      imagePath = 'assets/mastercard.png';
      cardColor = const Color.fromARGB(255, 192, 92, 21);
    } else if (firstDigit == 6) {
      imagePath = 'assets/Discover-removebg-preview.png';
      cardColor = Colors.grey;
    } else {
      // For other cases (fallback image)
      imagePath = 'assets/Others-removebg-preview.png';
      cardColor = Colors.black;
    }

    Future<void> deleteCard(String cardId) async {
      await CardModelFunctions().deleteCard(cardId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: expenseColor,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Card Deletd',
            textAlign: TextAlign.center,
          )));
    }

    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) {
              deleteCard(card.id);
            },
            backgroundColor: expenseColor,
            label: 'Delete',
            icon: Icons.delete,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenEditCard(
                    cardId: card.id,
                  ),
                ),
              );
            },
            backgroundColor: incomeColor,
            label: 'Edit',
            icon: Icons.edit,
          ),
        ],
      ),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          height: 240,
          width: 370,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/Chip_symbol_1-2-removebg-preview.png',
                  height: 50,
                  width: 50,
                ),
                Row(
                  children: [
                    Text(
                      card.cardNumber, // Display card number
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Copy card number to clipboard
                        Clipboard.setData(ClipboardData(text: card.cardNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Card number copied to clipboard',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: incomeColor,
                            duration: Duration(seconds: 2),
                            margin: EdgeInsets.all(10),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.content_copy, color: Colors.white),
                    )
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/Chip_symbol_1-3-removebg-preview.png',
                      height: 40,
                      width: 40,
                    ),
                    Text(
                      card.cardValid, // Display validThru
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Copy valid number to clipboard
                        Clipboard.setData(ClipboardData(text: card.cardValid));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Card valid copied to clipboard',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: incomeColor,
                            duration: Duration(seconds: 2),
                            margin: EdgeInsets.all(10),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.content_copy, color: Colors.white),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      card.cardHolder, // Display card holder
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      imagePath,
                      width: 50,
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
