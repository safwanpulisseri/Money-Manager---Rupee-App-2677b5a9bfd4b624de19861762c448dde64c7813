import 'package:flutter/material.dart';
import 'package:rupee_app/database/category_controller.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/screens/constraints/theme.dart';

class ScreenAddCategory extends StatefulWidget {
  final String selectedRadio;
  final Function updateCategories;

  const ScreenAddCategory({
    Key? key,
    required this.selectedRadio,
    required this.updateCategories,
  });

  @override
  State<ScreenAddCategory> createState() => _ScreenAddCategoryState();
}

class _ScreenAddCategoryState extends State<ScreenAddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange])),
          ),
          title: const Text('Add Category'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    errorStyle: TextStyle(
                        color: Colors.red), // Red-colored error message
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name'; // Validation message
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with adding category
                        String categoryName = categoryController.text.trim();
                        await CategoryModelFunctions()
                            .addCategory(CategoryModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          categories: categoryName,
                          isIncome: widget.selectedRadio == 'Option 1',
                        ));
                        widget.updateCategories();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: incomeColor,
                              duration: Duration(seconds: 2),
                              margin: EdgeInsets.all(10),
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Category Added successfully',
                                textAlign: TextAlign.center,
                              )),
                        );
                        Navigator.pop(context);
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
                        'ADD',
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
