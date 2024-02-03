import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/screens/constraints/theme.dart';

class EditTransactionScreen extends StatefulWidget {
  final String transactionId;

  const EditTransactionScreen({Key? key, required this.transactionId})
      : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  TransactionModel? transaction; // Transaction details
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTransactionDetails();
  }

  Future<void> fetchTransactionDetails() async {
    final box = await Hive.openBox<TransactionModel>('transactionBox');
    setState(() {
      transaction = box.get(widget.transactionId);
      // Prefill the controllers with the initial values
      amountController.text = transaction?.amount.toString() ?? '';
      descriptionController.text = transaction?.description ?? '';
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
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
                color: Colors.black,
              )),
          title: const Text(
            'Edit Transaction',
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // CircleAvatar(
                      //   radius: 40,
                      //   backgroundColor: Colors.transparent,
                      //   backgroundImage: AssetImage(
                      //       // transaction?.category.categoryImagePath ?? '',
                      //       ),
                      // ),
                      const SizedBox(height: 10),
                      Text(
                        transaction?.categoryName ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(25),
                  child: TextFormField(
                    //initialValue: transaction?.amount.toString() ?? '',
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: 15,
                      //   vertical: 15,
                      // ),
                      labelText: 'Amount',
                      labelStyle:
                          TextStyle(fontSize: 17, color: Colors.grey.shade800),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: TextFormField(
                    controller: descriptionController,
                    // initialValue: transaction?.description ?? '',
                    // keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: 15,
                      //   vertical: 15,
                      // ),
                      labelText: 'Description',
                      labelStyle:
                          TextStyle(fontSize: 17, color: Colors.grey.shade800),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                // Text('Amount: ${transaction?.amount}'),
                // SizedBox(height: 10),
                // Text('Description: ${transaction?.description}'),
                // // Add more fields to display transaction details
                // // ...
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: GestureDetector(
                    onTap: () async {
                      if (transaction != null) {
                        final updatedTransaction = TransactionModel(
                          id: transaction!.id,
                          amount: double.parse(amountController.text),
                          description: descriptionController.text,
                          date: transaction!.date,
                          categoryName: transaction!.categoryName,
                          isIncome: transaction!
                              .isIncome, // or false based on whether it's an income or expense
                        );
                        await TransactionModelFunctions().updateTransaction(
                            transaction!.id, updatedTransaction);

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: incomeColor,
                                duration: Duration(seconds: 2),
                                margin: EdgeInsets.all(10),
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Transaction Updated',
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
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const Text(
                        'Save Changes',
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
    );
  }
}
