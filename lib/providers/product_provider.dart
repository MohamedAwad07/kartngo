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
    await _insertMockDataIfNeeded();
    await loadProducts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _insertMockDataIfNeeded() async {
    final existing = await _repository.getProducts();
    if (existing.isEmpty) {
      final demoProducts = [
        Product(
          name: 'Double Whopper',
          price: 29.57,
          imageUrl: 'https://static.bkdelivery.com.sa/Images/Items/DoubleWhopper.png',
        ),
        Product(
          name: 'Steakhouse XI',
          price: 35.65,
          imageUrl: 'https://static.bkdelivery.com.sa/Images/Items/SteakhouseXI.png',
        ),
        Product(
          name: 'Chicken Steakhouse',
          price: 37.39,
          imageUrl: 'https://static.bkdelivery.com.sa/Images/Items/ChickenSteakhouse.png',
        ),
        Product(
          name: 'Steakhouse',
          price: 30.43,
          imageUrl: 'https://static.bkdelivery.com.sa/Images/Items/Steakhouse.png',
        ),
        Product(
          name: 'Quattro Cheese Grill',
          price: 29.57,
          imageUrl: 'https://static.bkdelivery.com.sa/Images/Items/QuattroCheeseGrill.png',
        ),
        Product(
          name: 'Quattro Cheese Chicken',
          price: 29.57,
          imageUrl: 'https://static.bkdelivery.com.sa/Images/Items/QuattroCheeseChicken.png',
        ),
      ];
      for (final p in demoProducts) {
        await _repository.addProduct(p);
      }
    }
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