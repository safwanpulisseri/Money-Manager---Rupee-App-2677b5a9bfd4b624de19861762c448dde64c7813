import 'package:fl_chart/fl_chart.dart';
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

class ScreenStatistics extends StatefulWidget {
  const ScreenStatistics({super.key});

  @override
  State<ScreenStatistics> createState() => _ScreenStatisticsState();
}

class _ScreenStatisticsState extends State<ScreenStatistics> {
  late List<TransactionModel> reversedTransactions =
      []; // Define reversedTransactions here
  late ValueNotifier<double> totalIncomeNotifier;
  late ValueNotifier<double> totalExpenseNotifier;
  late String currencySymbol;
  late List<UserModel> profileDetailsList;
  late String selectedCountry = 'IN';
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    totalIncomeNotifier = ValueNotifier<double>(0.0);
    totalExpenseNotifier = ValueNotifier<double>(0.0);
    calculateTotals(); // Calculate totals when initialized
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
    void _updateTotals() {
      final List<TransactionModel> transactions =
          Hive.box<TransactionModel>('transactionBox')
              .values
              .toList()
              .cast<TransactionModel>();

      double totalIncome = 0.0;
      double totalExpense = 0.0;

      for (var transaction in transactions) {
        if (transaction.isIncome) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      totalIncomeNotifier.value = totalIncome;
      totalExpenseNotifier.value = totalExpense;
    }

// Modify  deleteTransaction method
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
      _updateTotals(); // Update totals after deletion
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Statistics',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
          ),
        ),
        body: Container(
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
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 250,
                    width: 250, // Inside ValueListenableBuilder for PieChart
                    child: ValueListenableBuilder<Box<TransactionModel>>(
                      valueListenable:
                          Hive.box<TransactionModel>('transactionBox')
                              .listenable(),
                      builder: (context, box, child) {
                        final List<TransactionModel> transactions =
                            box.values.toList().cast<TransactionModel>();

                        if (transactions.isEmpty) {
                          return const Expanded(
                            child: Center(
                              // Display a message when transactions are empty
                              child: Text(
                                'No Graph available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }

                        // Filter transactions based on selected date range if the flag is true
                        final selectedTransactions = isDateFilterApplied
                            ? transactions.where(
                                (transaction) =>
                                    transaction.date
                                        .isAfter(selectedStartDate) &&
                                    transaction.date.isBefore(selectedEndDate),
                              )
                            : transactions;

                        // Calculate total income and expense for the selected transactions
                        double totalIncome = 0.0;
                        double totalExpense = 0.0;

                        if (selectedTransactions.isEmpty) {
                          return const Expanded(
                            child: Center(
                              // Display a message when no transactions are available in the selected date range
                              child: Text(
                                'No Graph available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }

                        for (var transaction in selectedTransactions) {
                          if (transaction.isIncome) {
                            totalIncome += transaction.amount;
                          } else {
                            totalExpense += transaction.amount;
                          }
                        }
                        // Update the PieChart data
                        return PieChart(
                          swapAnimationDuration:
                              const Duration(milliseconds: 750),
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: totalIncome,
                                color: Colors.green.shade400,
                              ),
                              PieChartSectionData(
                                value: totalExpense,
                                color: Colors.red.shade400,
                              ),
                            ],
                            sectionsSpace: 1,
                          ),
                        );
                        //   //  SfCircularChart
                        // return SfCircularChart(
                        //   series: <CircularSeries>[
                        //     PieSeries<TransactionModel, String>(
                        //       dataSource: [
                        //         // Data point for total income
                        //         TransactionModel(
                        //           id: 'total_income', // ID for total income
                        //           amount: totalIncome,
                        //           description:
                        //               'Total Income', // Description for total income
                        //           date: DateTime.now(), // Provide a valid date
                        //           categoryName:
                        //               'Total Income', // Category name for total income
                        //           isIncome: true,
                        //         ),
                        //         // Data point for total expense
                        //         TransactionModel(
                        //           id: 'total_expense', // ID for total expense
                        //           amount: totalExpense,
                        //           description:
                        //               'Total Expense', // Description for total expense
                        //           date: DateTime.now(), // Provide a valid date
                        //           categoryName:
                        //               'Total Expense', // Category name for total expense
                        //           isIncome: false,
                        //         ),
                        //       ],
                        //       xValueMapper: (TransactionModel data, _) =>
                        //           data.categoryName,
                        //       yValueMapper: (TransactionModel data, _) =>
                        //           data.amount,
                        //     ),
                        //   ],
                        // );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Top Transactions',
                          style: TextStyle(fontSize: 22),
                        ),
                        IconButton(
                          onPressed: () {
                            _showDateSelectionModal(context);
                          },
                          icon: const Icon(Icons.filter_list),
                        ),
                      ],
                    ),
                  ),

                  // List of Top Transactions
                  ValueListenableBuilder<Box<TransactionModel>>(
                    valueListenable:
                        Hive.box<TransactionModel>('transactionBox')
                            .listenable(),
                    builder: (context, box, child) {
                      final List<TransactionModel> transactions =
                          box.values.toList().cast<TransactionModel>();

                      // Filter transactions between selected dates
                      final filteredTransactions = isDateFilterApplied
                          ? reversedTransactions
                          : transactions.reversed.toList();

                      // Reverse the list to show most recent transactions first
                      reversedTransactions =
                          filteredTransactions.toList().reversed.toList();

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

                      return Expanded(
                        child: reversedTransactions.isEmpty
                            ? const Expanded(
                                child: Center(
                                  // Message when no transactions are available
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No transactions available',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                      Text(
                                        'in selected date range',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: reversedTransactions.length,
                                itemBuilder: (context, index) {
                                  final TransactionModel transaction =
                                      reversedTransactions[index];
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
                                        //extentRatio: 0.5,
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
                                        //     // child: Image.asset(
                                        //     //     // category.categoryImagePath,
                                        //     //     // height: 100,
                                        //     //     // width: 100,
                                        //     //     // fit: BoxFit.cover,
                                        //     //     ),
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
    );
  }

  bool isDateFilterApplied = false;
  void loadTransactionsBetweenDates() {
    final Box<TransactionModel> transactionBox =
        Hive.box<TransactionModel>('transactionBox');

    final List<TransactionModel> transactions =
        transactionBox.values.toList().cast<TransactionModel>();

    if (selectedStartDate != null && selectedEndDate != null) {
      final filteredTransactions = transactions.where((transaction) =>
          transaction.date.isAfter(selectedStartDate) &&
          transaction.date.isBefore(selectedEndDate));

      setState(() {
        reversedTransactions = filteredTransactions.toList().reversed.toList();
        isDateFilterApplied = true; // Date filter is applied
      });
      if (filteredTransactions.isEmpty) {
        // Show a message when there are no transactions in the selected date range
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: expenseColor,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
              content: Text(
                'No transactions in selected date range',
                textAlign: TextAlign.center,
              )),
        );
      }
    } else {
      // Show all transactions if no date range is selected
      setState(() {
        reversedTransactions = transactions.reversed.toList();
        isDateFilterApplied = false; // Date filter is not applied
      });
    }
  }

  void _showDateSelectionModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Filter By',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Start Date:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      DateSelector(
                        initialDate: selectedStartDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedStartDate = date;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'End Date:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      DateSelector(
                        initialDate: selectedEndDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedEndDate = date;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the modal
                      //loadTransactionsBetweenDates();
                      _validateAndLoadTransactions();
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Colors.red,
                          Colors.orange,
                        ]),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                          Icon(
                            Icons.filter_list,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _validateAndLoadTransactions() {
    if (selectedStartDate.isAfter(selectedEndDate)) {
      // Show an error message if the start date is after the end date
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: expenseColor,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Start date cannot be after end date',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      // Load transactions if the date range is valid
      loadTransactionsBetweenDates();
    }
  }

  void calculateTotals() {
    final Box<TransactionModel> transactionBox =
        Hive.box<TransactionModel>('transactionBox');

    updateTotals(transactionBox.values.toList().cast<TransactionModel>());

    transactionBox.listenable().addListener(() {
      updateTotals(transactionBox.values.toList().cast<TransactionModel>());
    });
  }

  void updateTotals(List<TransactionModel> transactions) {
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (var transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    totalIncomeNotifier.value = totalIncome;
    totalExpenseNotifier.value = totalExpense;
  }

  List day = [
    'Day',
    'Week',
    'Month',
    'Year',
  ];

  int index_color = 0;
}

class DateSelector extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          // Customize the date picker's theme
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                      color: datePickerText), // Change text color here
                ),
                colorScheme: ColorScheme.light(
                  primary: selectedDateColor, // Change selected date color here
                ).copyWith(
                    background:
                        datePickerBackground), // Change background color here
              ),
              child: child ?? Container(),
            );
          },
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
          });
          widget
              .onDateSelected(picked); // Notify parent about the selected date
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Select Date',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
