import 'package:sqflite/sqflite.dart' as sql;
import 'package:money/model/database_helper.dart';
import 'package:money/model/category.dart';
import 'package:money/model/transaction.dart';

class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertCategory(Category category) async {
    final db = await _dbHelper.database;
    return await db.insert('categories', category.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Category>> getCategories({String? type}) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: type != null ? 'type = ?' : null,
      whereArgs: type != null ? [type] : null,
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> updateCategory(Category category) async {
    final db = await _dbHelper.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Category?> getCategoryById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }
}

class TransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.insert('transactions', transaction.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Transaction>> getTransactions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        T.*,
        C.name AS categoryName,
        C.type AS categoryType,
        C.color AS categoryColor
      FROM transactions AS T
      LEFT JOIN categories AS C ON T.categoryId = C.id
      ORDER BY T.date DESC
    ''');

    return List.generate(maps.length, (i) {
      final transaction = Transaction.fromMap(maps[i]);
      if (maps[i]['categoryId'] != null) {
        transaction.category = Category(
          id: maps[i]['categoryId'],
          name: maps[i]['categoryName'],
          type: maps[i]['categoryType'],
          color: maps[i]['categoryColor'],
        );
      }
      return transaction;
    });
  }

  Future<int> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}