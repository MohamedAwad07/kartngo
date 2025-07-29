import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../data/app_repository.dart';

class ProductProvider extends ChangeNotifier {
  late Database _db;
  late AppRepository _repository;
  List<Product> _products = [];
  bool _isLoading = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductProvider() {
    _initDb();
  }

  Future<void> _initDb() async {
    _isLoading = true;
    notifyListeners();
    _db = await openDatabase(
      join(await getDatabasesPath(), 'products.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, imageUrl TEXT, quantity INTEGER)',
        );
      },
      version: 1,
    );
    _repository = AppRepository(_db);
    await loadProducts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _products = await _repository.getProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _repository.addProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _repository.updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await _repository.deleteProduct(id);
    await loadProducts();
  }
} 