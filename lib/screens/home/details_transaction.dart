import 'package:flutter/material.dart';

import 'package:rupee_app/model/db_transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final CategoryModel category = transaction.category;
    final DateTime date = transaction.date;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              transaction.categoryName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            // leading: CircleAvatar(
            //   backgroundColor: Colors.transparent,
            //   radius: 30,
            //   child: ClipOval(
            //     child: Image.asset(
            //       category.categoryImagePath,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Text(
              '${transaction.amount}',
              style: TextStyle(
                  color: transaction.isIncome ? Colors.green : Colors.red,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Description: ${transaction.description}',
              style: const TextStyle(fontSize: 18),
            ),
            // Other details you want to display
          ],
        ),
      ),
    );
  }
}
