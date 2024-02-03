import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/details_transaction.dart';
import 'package:rupee_app/screens/home/edit_transaction.dart';

class ScreenSeeAllTransaction extends StatefulWidget {
  const ScreenSeeAllTransaction({super.key});

  @override
  State<ScreenSeeAllTransaction> createState() =>
      _ScreenSeeAllTransactionState();
}

class _ScreenSeeAllTransactionState extends State<ScreenSeeAllTransaction> {
  String searchQuery = '';
  String selectedRadio = 'All'; // Track selected radio button
  late String currencySymbol;
  late List<UserModel> profileDetailsList;
  late String selectedCountry = '';
  @override
  void initState() {
    super.initState();
    _initializeCountryData();
    _fetchUserCountry();
    profileDetailsList = [];
  }

  void _fetchUserCountry() {
    final UserProfileFunctions profileFunctions = UserProfileFunctions();
    profileDetailsList = profileFunctions.getAllProfileDetails();
    if (profileDetailsList.isNotEmpty) {
      selectedCountry = profileDetailsList.first.country;
      _initializeCountryData();
    }
  }

  // Map country to currency symbol
  void _initializeCountryData() {
    Map<String, String> countryToCurrency = {
      'US': '\$', // Dollar for the United States
      'CN': '¥', // Chinese Yuan
      'IN': '₹', // Indian Rupee
      'ID': 'Rp', // Indonesian Rupiah
      'BR': 'R', // Brazilian Real
      'RU': '₽', // Russian Ruble
      'NG': '₦', // Nigerian Naira
      'EG': 'E£', // Egyptian Pound
      'DE': '€', // Euro for Germany
      'FR': '€', // Euro for France
      'GB': '£', // Pound Sterling for the United Kingdom
      'IT': '€', // Euro for Italy
      'ES': '€', // Euro for Spain
      'AE': 'د.إ', // UAE Dirham
      'SA': '﷼', // Saudi Riyal
      'JP': '¥', // Japanese Yen
      'KR': '₩', // South Korean Won
      'TH': '฿', // Thai Baht
      'MY': 'RM', // Malaysian Ringgit
      'VN': '₫', // Vietnamese Dong
      'PH': '₱', // Philippine Peso
      'SG': '\$', // Singapore Dollar
      'BD': '৳', // Bangladeshi Taka
      'PK': '₨', // Pakistani Rupee
      'LK': 'රු', // Sri Lankan Rupee
      'QA': '﷼', // Qatari Riyal
      'KW': 'د.ك', // Kuwaiti Dinar
      'OM': 'ر.ع.', // Omani Rial
      'BH': 'د.ب', // Bahraini Dinar
      'JO': 'د.ا', // Jordanian Dinar
      'SE': 'kr', // Swedish Krona
      'NL': '€', // Euro for Netherlands
      'CH': 'CHF', // Swiss Franc
      'PL': 'zł', // Polish Złoty
      'TR': '₺', // Turkish Lira
    };

    currencySymbol = countryToCurrency[selectedCountry] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Future<void> deleteTransaction(String transactionId) async {
      await TransactionModelFunctions().deleteTransaction(transactionId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: expenseColor,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Transaction Deleted',
            textAlign: TextAlign.center,
          )));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.red,
              Colors.orange,
            ])),
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
            'Transaction History',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.orange,
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: Container(
                height: 840,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: TextField(
                          cursorHeight: 35,
                          style: const TextStyle(fontSize: 20),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search',
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.orange, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        radioWidget('All'),
                        radioWidget('AllIncome'),
                        radioWidget('AllExpense'),
                      ],
                    ),
                    ValueListenableBuilder<Box<TransactionModel>>(
                      valueListenable:
                          Hive.box<TransactionModel>('transactionBox')
                              .listenable(),
                      builder: (context, box, child) {
                        final List<TransactionModel> transactions =
                            box.values.toList().cast<TransactionModel>();
                        List<TransactionModel> filteredTransactions;

                        // Apply filter based on selected radio button
                        if (selectedRadio == 'AllIncome') {
                          filteredTransactions = transactions
                              .where((transaction) => transaction.isIncome)
                              .toList();
                        } else if (selectedRadio == 'AllExpense') {
                          filteredTransactions = transactions
                              .where((transaction) => !transaction.isIncome)
                              .toList();
                        } else {
                          filteredTransactions = transactions;
                        }

                        // Apply additional search query filter
                        filteredTransactions =
                            filteredTransactions.where((transaction) {
                          final String transactionName =
                              transaction.categoryName.toLowerCase();
                          final String query = searchQuery.toLowerCase();
                          return transactionName.contains(query);
                        }).toList();
                        if (transactions.isEmpty) {
                          return const Expanded(
                            child: Center(
                              // Message when no transactions are available
                              child: Text(
                                'No transactions available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }
                        if (filteredTransactions.isEmpty) {
                          return const Center(
                            // Message when no transactions are available
                            child: Text(
                              'No transactions found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final TransactionModel transaction =
                                  filteredTransactions.reversed.toList()[index];
                              // final CategoryModel category =
                              //     transaction.category;
                              final DateTime date = transaction.date;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionDetailScreen(
                                              transaction: transaction),
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
                                          // Remove transaction from the database
                                          deleteTransaction(transaction.id);
                                          // Update UI as needed
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
                                              builder: (context) =>
                                                  EditTransactionScreen(
                                                      transactionId:
                                                          transaction.id),
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
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                        '${date.day}/${date.month}/${date.year}'),
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
                                            color: transaction.isIncome
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 0,
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
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to build Radio widgets
  Widget radioWidget(String value) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedRadio = value; // Update selected radio value
            });
          },
          child: Radio(
            value: value,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                selectedRadio = value.toString(); // Update selected radio value
              });
            },
          ),
        ),
        Text(
          value == 'AllIncome'
              ? 'Income'
              : value == 'AllExpense'
                  ? 'Expense'
                  : 'All',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
