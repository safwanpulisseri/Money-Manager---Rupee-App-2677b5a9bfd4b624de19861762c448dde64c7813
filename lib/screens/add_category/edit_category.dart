import 'package:flutter/material.dart';
import 'package:rupee_app/database/category_controller.dart';
import 'package:rupee_app/model/db_category.dart';
import 'package:rupee_app/screens/constraints/theme.dart';

class ScreenEditCategory extends StatefulWidget {
  final CategoryModel category;
  final Function onUpdate;

  const ScreenEditCategory({
    Key? key,
    required this.category,
    required this.onUpdate,
  });
  @override
  State<ScreenEditCategory> createState() => _ScreenEditCategoryState();
}

class _ScreenEditCategoryState extends State<ScreenEditCategory> {
  final TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryController.text = widget.category.categories;
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
          title: const Text('Edit Category'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
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
                padding: const EdgeInsets.all(30),
                child: GestureDetector(
                  onTap: () async {
                    String newCategoryName = categoryController.text.trim();
                    await CategoryModelFunctions().updateCategory(
                      widget.category.id,
                      CategoryModel(
                        id: widget.category.id,
                        categories: newCategoryName,
                        isIncome: widget
                            .category.isIncome, // Retain the existing value
                      ),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: incomeColor,
                          duration: Duration(seconds: 2),
                          margin: EdgeInsets.all(10),
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Category Updated',
                            textAlign: TextAlign.center,
                          )),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }
}
