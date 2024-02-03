import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:rupee_app/database/category_controller.dart';
import 'package:rupee_app/database/transaction_controller.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/model/db_transaction.dart';
import 'package:rupee_app/screens/constraints/theme.dart';

class ScreenMainAdding extends StatefulWidget {
  const ScreenMainAdding({Key? key}) : super(key: key);

  @override
  State<ScreenMainAdding> createState() => _ScreenMainAddingState();
}

class _ScreenMainAddingState extends State<ScreenMainAdding> {
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey for form validation
  String selectedRadio = 'Option 1';

  List<String> incomeCategories = [];
  List<String> expenseCategories = [];

  Future<void> _addCategoryToDatabase(String category) async {
    final categoryModel = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categories: category,
      isIncome: selectedRadio == 'Option 1',
    );
    await CategoryModelFunctions().addCategory(categoryModel);
  }

  Future<void> _saveTransaction() async {
    // Retrieve values from controllers and variables
    double amount = double.tryParse(amount_C.text) ?? 0.0;
    String description = explain_C.text;
    //DateTime date = DateTime.now();
    String selectedCategory =
        selectedItem ?? "Others"; // Use a default if no category selected

    // Create a transaction model instance
    TransactionModel newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      description: description,
      date: this.date,
      categoryName: selectedCategory, // Assign the selected category name
      isIncome: selectedRadio == 'Option 1', // Check if it's income or expense
    );
    // Call the function to add the transaction to the database
    await TransactionModelFunctions()
        .addTransaction(newTransaction, selectedRadio);

    var hiveBox = await Hive.openBox<TransactionModel>('transactionBox');
    final allData = hiveBox.values.toList();
    log(allData.length.toString());
    // for (var data in allData) {
    //   log("Diary Entry: key=${data.id} Date=${data.date}, Title=${data.amount}, Content=${data.description}, ");
    // }
  }

  void _handleRadioValueChanged(String value) {
    setState(() {
      selectedRadio = value;
      selectedItem = null; // Reset selected category when radio button changes
    });
  }

  DateTime date = DateTime.now();
  String? selectedItem;
  final TextEditingController explain_C = TextEditingController();

  FocusNode ex = FocusNode();
  final TextEditingController amount_C = TextEditingController();
  FocusNode amount = FocusNode();

  int index = 0;

  @override
  void initState() {
    super.initState();
    ex.addListener(() {
      setState(() {});
    });
    amount.addListener(() {
      setState(() {});
    });
    loadCategoriesFromDatabase();
  }

  void loadCategoriesFromDatabase() async {
    await CategoryModelFunctions().getCategoriesFromDatabase();
    // Filter and update income and expense categories
    incomeCategories = categoryModelNotifier.value
        .where((category) => category.isIncome)
        .map((category) => category.categories)
        .toList();
    expenseCategories = categoryModelNotifier.value
        .where((category) => !category.isIncome)
        .map((category) => category.categories)
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
          title: const Text(
            'Adding',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            backgroundContainer(context),
            Positioned(
              top: 50,
              child: mainContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Container mainContainer() {
    return Container(
      height: 600,
      width: 350,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey,
            offset: Offset(5, 5),
          ),
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey,
            offset: Offset(-1, -1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              category_selection(),
              const SizedBox(
                height: 50,
              ),
              amounts(),
              const SizedBox(
                height: 20,
              ),
              explain(),
              const SizedBox(
                height: 20,
              ),
              categories(),
              const SizedBox(
                height: 20,
              ),
              day_month_year(),
              const SizedBox(
                height: 40,
              ),
              save_button(),
            ],
          ),
        ),
      ),
    );
  }

  Row category_selection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _handleRadioValueChanged('Option 1');
          },
          child: Radio(
            value: 'Option 1',
            groupValue: selectedRadio,
            onChanged: (value) {
              _handleRadioValueChanged(value as String);
            },
          ),
        ),
        const Text(
          'Income',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () {
            _handleRadioValueChanged('Option 2');
          },
          child: Radio(
            value: 'Option 2',
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                selectedRadio = value as String;
              });
            },
          ),
        ),
        const Text(
          'Expense',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  GestureDetector save_button() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          await _saveTransaction();
          // Perform any necessary action after saving, such as navigating back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Transaction Added',
                textAlign: TextAlign.center,
              ),
              backgroundColor: incomeColor,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  void _showDatePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: TextTheme(
              bodyLarge:
                  TextStyle(color: datePickerText), // Change text color here
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
    if (newDate != null) {
      setState(() {
        date = newDate;
      });
    }
  }

  Container day_month_year() {
    return Container(
      alignment: Alignment.bottomLeft,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Colors.grey,
        ),
      ),
      child: TextButton(
        onPressed: () async {
          _showDatePicker();
        },
        child: Text(
          'Date: ${DateFormat('dd/MM/yyyy').format(date)}', // Display selected date
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Padding explain() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Description is required';
          }
          return null;
        },
        focusNode: ex,
        controller: explain_C,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          labelText: 'Description',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade800),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 2,
                color: Colors.grey,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Padding amounts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Amount is required';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        focusNode: amount,
        controller: amount_C,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          labelText: 'Amount',
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade800),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 2,
                color: Colors.grey,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Padding categories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade600,
            width: 1.5,
          ),
        ),
        child: ValueListenableBuilder<List<CategoryModel>>(
          valueListenable: CategoryModelFunctions().getCategoriesNotifier(),
          builder: (context, categories, child) {
            List<DropdownMenuItem<String>> dropdownItems = [];
            for (var category in selectedRadio == 'Option 1'
                ? incomeCategories
                : expenseCategories) {
              dropdownItems.add(
                DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Text(category),
                    ],
                  ),
                ),
              );
            }
            dropdownItems.add(
              const DropdownMenuItem(
                value: 'Add Category',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text('Add Category'),
                  ],
                ),
              ),
            );
            return DropdownButton<String>(
              value: selectedItem,
              items: dropdownItems,
              onChanged: (value) {
                setState(() {
                  selectedItem = value!;
                  if (value == 'Add Category') {
                    _showAddCategoryDialog();
                  }
                });
              },
              hint: const Text('Category'),
              dropdownColor: Colors.white,
              isExpanded: true,
              underline: Container(),
            );
          },
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    String newCategoryName = '';
    bool showError = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Add Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      newCategoryName = value;
                      setState(() {
                        showError = false;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Category Name',
                      errorText: showError && newCategoryName.isEmpty
                          ? 'Please add category name'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (newCategoryName.isEmpty) {
                            setState(() {
                              showError = true;
                            });
                          } else {
                            final categoryFunctions = CategoryModelFunctions();
                            await categoryFunctions.addCategory(
                              CategoryModel(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                categories: newCategoryName,
                                isIncome: selectedRadio == 'Option 1',
                              ),
                            );
                            await categoryFunctions.getCategoriesFromDatabase();
                            loadCategoriesFromDatabase();

                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: incomeColor,
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
      },
    );
  }

  Column backgroundContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.orange,
              ],
            ),
          ),
        )
      ],
    );
  }
}
