import 'package:sqflite/sqflite.dart';
import '../models/product.dart';
import 'product_dao.dart';

class AppRepository {
  final ProductDao productDao;

  AppRepository(Database db) : productDao = ProductDao(db);

  Future<List<Product>> getProducts() => productDao.getAllProducts();
  Future<void> addProduct(Product product) => productDao.insertProduct(product);
  Future<void> updateProduct(Product product) => productDao.updateProduct(product);
  Future<void> deleteProduct(int id) => productDao.deleteProduct(id);
} 