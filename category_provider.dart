import 'package:flutter/material.dart';
import 'package:money/model/category.dart';
import 'package:money/model/repositories.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();
  List<Category> _categories = [];
  List<Category> _incomeCategories = [];
  List<Category> _expenseCategories = [];

  List<Category> get categories => _categories;
  List<Category> get incomeCategories => _incomeCategories;
  List<Category> get expenseCategories => _expenseCategories;

  CategoryProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    _categories = await _repository.getCategories();
    _incomeCategories = _categories.where((c) => c.type == 'income').toList();
    _expenseCategories = _categories.where((c) => c.type == 'expense').toList();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await _repository.insertCategory(category);
    await fetchCategories();
  }

  Future<void> updateCategory(Category category) async {
    await _repository.updateCategory(category);
    await fetchCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _repository.deleteCategory(id);
    await fetchCategories();
  }
}