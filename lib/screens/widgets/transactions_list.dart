import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/details_transaction.dart';
import 'package:rupee_app/screens/home/edit_transaction.dart';

class TransactionListWidget extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(String) deleteTransaction;
  final String currencySymbol;
  const TransactionListWidget({
    super.key,
    required this.transactions,
    required this.deleteTransaction,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final TransactionModel transaction = transactions[index];
          final DateTime date = transaction.date;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TransactionDetailScreen(transaction: transaction),
                ),
              );
            },
            child: Slidable(
              startActionPane: (ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: expenseColor,
                    onPressed: (ctx) {
                      deleteTransaction(transaction.id);
                    },
                    label: 'Delete',
                    icon: Icons.delete,
                  ),
                ],
              )),
              endActionPane: (ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: incomeColor,
                    onPressed: (ctx) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTransactionScreen(
                              transactionId: transaction.id),
                        ),
                      );
                    },
                    icon: Icons.edit,
                    label: 'Edit',
                  )
                ],
              )),
              child: ListTile(
                title: Text(
                  transaction.categoryName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text('${date.day}/${date.month}/${date.year}'),
                // leading: CircleAvatar(
                //   backgroundColor: Colors.transparent,
                //   radius: 30,
                //   child: ClipOval(
                //     child: Image.asset(
                //      // category.categoryImagePath,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$currencySymbol${transaction.amount}',
                      style: TextStyle(
                        color: transaction.isIncome ? Colors.green : Colors.red,
                        fontSize: 20,
                      ),
                    ),
                    transaction.isIncome
                        ? Image.asset(
                            'assets/icon_income copy.png',
                            height: 20,
                            width: 20,
                          )
                        : Image.asset(
                            'assets/icon_expense-2.png',
                            height: 20,
                            width: 20,
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
