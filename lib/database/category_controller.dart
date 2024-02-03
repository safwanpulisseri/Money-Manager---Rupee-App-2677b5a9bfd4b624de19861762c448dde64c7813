import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/model/db_category.dart';

final ValueNotifier<List<CategoryModel>> categoryModelNotifier =
    ValueNotifier<List<CategoryModel>>([]);

class CategoryModelFunctions {
  static const String categoryBoxName = 'categoriesBox';

  Future<Box<CategoryModel>> _openBox() async {
    return await Hive.openBox<CategoryModel>('categoriesBox');
  }

  Future<void> addCategory(CategoryModel category) async {
    final box = await _openBox();
    await box.put(category.id, category);
    categoryModelNotifier.value = box.values.toList(); // Update notifier
    categoryModelNotifier.notifyListeners();
    await getCategoriesFromDatabase();
  }

  ValueNotifier<List<CategoryModel>> getCategoriesNotifier() {
    return categoryModelNotifier;
  }

  Future getCategoriesFromDatabase() async {
    final box = await _openBox();
    final categories = box.values.toList();
    categoryModelNotifier.value = categories; // Update notifier
    categoryModelNotifier.notifyListeners();
  }

  Future<void> deleteCategory(String categoryId) async {
    final box = await _openBox();
    await box.delete(categoryId);
    categoryModelNotifier.value = box.values.toList(); // Update notifier
    categoryModelNotifier.notifyListeners();
    await getCategoriesFromDatabase();
  }

  Future<void> updateCategory(
      String categoryId, CategoryModel updatedCategory) async {
    final box = await _openBox();
    await box.put(categoryId, updatedCategory);
    categoryModelNotifier.value = box.values.toList(); // Update notifier
    categoryModelNotifier.notifyListeners();
    await getCategoriesFromDatabase();
  }
}
