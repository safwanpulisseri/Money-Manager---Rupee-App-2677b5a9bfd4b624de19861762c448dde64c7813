import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rupee_app/database/category_controller.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/screens/add_category/add_category.dart';
import 'package:rupee_app/screens/add_category/edit_category.dart';
import 'package:rupee_app/screens/constraints/theme.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory> {
  String selectedRadio =
      'Option 1'; // Set the initial selection to 'Option 1' (Income)
  late List<CategoryModel> displayedCategories;

  @override
  void initState() {
    super.initState();
    displayedCategories =
        CategoryModelFunctions().getCategoriesNotifier().value;
    updateDisplayedCategories();
    CategoryModelFunctions()
        .getCategoriesFromDatabase(); // Ensure you fetch categories initially
  }

  @override
  void dispose() {
    CategoryModelFunctions().getCategoriesNotifier().removeListener(updateUI);
    super.dispose();
  }

  void updateUI() {
    updateDisplayedCategories();
  }

  void updateDisplayedCategories() async {
    await CategoryModelFunctions().getCategoriesFromDatabase();
    List<CategoryModel> allCategories = categoryModelNotifier.value;

    if (selectedRadio == 'Option 1') {
      setState(() {
        displayedCategories =
            allCategories.where((category) => category.isIncome).toList();
      });
    } else {
      setState(() {
        displayedCategories =
            allCategories.where((category) => !category.isIncome).toList();
      });
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
          title: const Text('Category'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context,
                  true); // Navigate back and indicate a reload is needed
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenAddCategory(
                      selectedRadio: selectedRadio,
                      updateCategories: updateDisplayedCategories,
                    ),
                  ),
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: 'Option 1',
                      groupValue: selectedRadio,
                      onChanged: (value) {
                        setState(() {
                          selectedRadio = value as String;
                          updateDisplayedCategories();
                        });
                      },
                    ),
                    const Text(
                      'Income',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Radio(
                      value: 'Option 2',
                      groupValue: selectedRadio,
                      onChanged: (value) {
                        setState(() {
                          selectedRadio = value as String;
                          updateDisplayedCategories();
                        });
                      },
                    ),
                    const Text(
                      'Expense',
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: categoryModelNotifier,
                builder: (context, categories, child) {
                  // Separate income and expense categories
                  List<CategoryModel> incomeCategories = categories
                      .where((category) => category.isIncome)
                      .toList();
                  List<CategoryModel> expenseCategories = categories
                      .where((category) => !category.isIncome)
                      .toList();

                  // Display categories based on selected radio button
                  List<CategoryModel> displayedCategories =
                      selectedRadio == 'Option 1'
                          ? incomeCategories
                          : expenseCategories;
                  if (displayedCategories.isEmpty) {
                    return const Expanded(
                      child: Center(
                        // Message when no transactions are available
                        child: Text(
                          'No category available',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: displayedCategories.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          startActionPane: (ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: expenseColor,
                                onPressed: (ctx) async {
                                  await CategoryModelFunctions().deleteCategory(
                                    displayedCategories[index].id,
                                  );
                                  updateDisplayedCategories();
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
                                      builder: (context) => ScreenEditCategory(
                                        category: displayedCategories[index],
                                        onUpdate: () {
                                          // Update the displayed categories when changes occur
                                          updateDisplayedCategories();
                                        },
                                      ),
                                    ),
                                  );
                                },
                                icon: Icons.edit,
                                label: 'Edit',
                              )
                            ],
                          )),
                          child: ListTile(
                            title: Text(displayedCategories[index].categories),
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
    );
  }
}
