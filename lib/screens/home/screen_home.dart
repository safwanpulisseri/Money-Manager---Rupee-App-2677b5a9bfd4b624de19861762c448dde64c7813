import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/constraints/theme.dart';
import 'package:rupee_app/screens/home/drawer.dart';
import 'package:rupee_app/screens/home/see_all.dart';
import 'package:rupee_app/screens/widgets/time.dart';
import 'package:rupee_app/screens/widgets/transactions_list.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late List<UserModel> profileDetailsList;
  late String selectedCountry;
  late String currencySymbol;

  @override
  void initState() {
    super.initState();
    UserProfileFunctions().getAllProfileDetails();
    TransactionModelFunctions().getAllTransactions();
    profileDetailsList = [];
    selectedCountry =
        'IN'; // default country or retrieve from stored user details
    _initializeCountryData();
    TransactionModelFunctions().getAllTransactions();
    _fetchUserCountry();
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
    // Fetch transaction details from the database
    // Here, might use transactionModelNotifier or another way to fetch data
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
        drawer: const CustomDrawer(),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            // SCREEN ONE

            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 170,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${GreetingWidget().getGreeting()},',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              ValueListenableBuilder<Box<UserModel>>(
                                valueListenable:
                                    Hive.box<UserModel>('userProfileBox')
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
                                        profileDetails.name.isNotEmpty) {
                                      return Row(
                                        children: [
                                          Text(
                                            '${profileDetails.name}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                  // Default text if no name is added
                                  return const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hi, User',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Row(
                                children: [
                                  ValueListenableBuilder<
                                      List<TransactionModel>>(
                                    valueListenable: transactionModelNotifier,
                                    builder: (context, transactions, child) {
                                      double totalIncome = 0.0;
                                      double totalExpense = 0.0;

                                      for (var transaction in transactions) {
                                        if (transaction.isIncome) {
                                          totalIncome += transaction.amount;
                                        } else {
                                          totalExpense += transaction.amount;
                                        }
                                      }

                                      // Calculate balance here
                                      double totalBalance =
                                          totalIncome - totalExpense;

                                      return Row(
                                        children: [
                                          Text(
                                            '$currencySymbol $totalBalance', // Display calculated balance
                                            style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'your balance',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // CenterWhitecontainer
                Container(
                  height: 560,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 5,
                            child: Container(
                              height: 100,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Income',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ValueListenableBuilder<
                                          List<TransactionModel>>(
                                        valueListenable:
                                            transactionModelNotifier,
                                        builder:
                                            (context, transactions, child) {
                                          double totalIncome = 0.0;
                                          double totalExpense = 0.0;

                                          for (var transaction
                                              in transactions) {
                                            if (transaction.isIncome) {
                                              totalIncome += transaction.amount;
                                            } else {
                                              totalExpense +=
                                                  transaction.amount;
                                            }
                                          }

                                          return Text(
                                            '$currencySymbol $totalIncome',
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                              height: 100,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Expense',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ValueListenableBuilder<
                                          List<TransactionModel>>(
                                        valueListenable:
                                            transactionModelNotifier,
                                        builder:
                                            (context, transactions, child) {
                                          double totalIncome = 0.0;
                                          double totalExpense = 0.0;

                                          for (var transaction
                                              in transactions) {
                                            if (transaction.isIncome) {
                                              totalIncome += transaction.amount;
                                            } else {
                                              totalExpense +=
                                                  transaction.amount;
                                            }
                                          }

                                          return Text(
                                            '$currencySymbol $totalExpense',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Transaction',
                              style: TextStyle(fontSize: 22),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: const BorderSide(color: Colors.black),
                                minimumSize: const Size(0, 30),
                                backgroundColor: Colors.grey[200],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ScreenSeeAllTransaction()));
                              },
                              child: const Text(
                                'See all',
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),

                      ValueListenableBuilder<Box<TransactionModel>>(
                        valueListenable:
                            Hive.box<TransactionModel>('transactionBox')
                                .listenable(),
                        builder: (context, box, child) {
                          final List<TransactionModel> transactions =
                              box.values.toList().cast<TransactionModel>();
                          // Reverse the list to show most recent transactions first
                          final List<TransactionModel> reversedTransactions =
                              transactions.reversed.toList();
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
                          return TransactionListWidget(
                            transactions: reversedTransactions,
                            deleteTransaction: deleteTransaction,
                            currencySymbol: currencySymbol,
                          );
                        },
                      ), // List of Recent Transactions
                    ],
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
