import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ironachle.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Cart table
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price TEXT NOT NULL,
        image TEXT NOT NULL,
        color TEXT NOT NULL,
        size INTEGER NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_name TEXT NOT NULL,
        product_price TEXT NOT NULL,
        product_image TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        subtotal REAL NOT NULL,
        tax REAL NOT NULL,
        delivery REAL NOT NULL,
        total REAL NOT NULL,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        order_date TEXT NOT NULL
      )
    ''');

    // Wishlist table
    await db.execute('''
      CREATE TABLE wishlist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price TEXT NOT NULL,
        image TEXT NOT NULL,
        rating REAL NOT NULL
      )
    ''');
  }

  // ─── CART CRUD ────────────────────────────────────────────

  Future<int> insertCartItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('cart', item);
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('cart');
  }

  Future<int> deleteCartItem(int id) async {
    final db = await database;
    return await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }

  // ─── ORDERS CRUD ──────────────────────────────────────────

  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.insert('orders', order);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('orders', orderBy: 'id DESC');
  }

  // ─── WISHLIST CRUD ────────────────────────────────────────

  Future<int> insertWishlist(Map<String, dynamic> item) async {
    final db = await database;
    // duplicate check
    final existing = await db.query(
      'wishlist',
      where: 'name = ?',
      whereArgs: [item['name']],
    );
    if (existing.isNotEmpty) return 0;
    return await db.insert('wishlist', item);
  }

  Future<List<Map<String, dynamic>>> getWishlist() async {
    final db = await database;
    return await db.query('wishlist');
  }

  Future<int> deleteWishlistItem(int id) async {
    final db = await database;
    return await db.delete('wishlist', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isInWishlist(String name) async {
    final db = await database;
    final result =
        await db.query('wishlist', where: 'name = ?', whereArgs: [name]);
    return result.isNotEmpty;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
