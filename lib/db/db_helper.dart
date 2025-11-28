
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;

  DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }


  // Initialize/ create Database

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'contacts_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }


// Create the app tables

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        image BLOB,
        call_date TEXT,
        isFav INTEGER NOT NULL DEFAULT 0,
         FOREIGN KEY (user_id) REFERENCES users(id)
        
      )
    ''');

    await db.execute('''
      CREATE TABLE call_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contact_id INTEGER NOT NULL,
        call_date TEXT NOT NULL,
        FOREIGN KEY (contact_id) REFERENCES contacts(id)
      )
    ''');
  }



//User Creation and sign in

  /// create
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert("users", row);
  }
  /// authenticate/ login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    Database db = await instance.database;
    var result = await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) return result.first;
    return null;
  }
  // get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }


  // CONTACT CRUD


  Future<int> insertContact(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert("contacts", row);
  }

  Future<List<Map<String, dynamic>>> getContactsByUser(int userId) async {
    Database db = await instance.database;
    return await db.query(
      "contacts",
      where: "user_id = ?",
      whereArgs: [userId],
    );
  }

  Future<int> deleteContact(int id) async {
    Database db = await instance.database;

    //Delete related call history entries
    await db.delete(
      "call_history",
      where: "contact_id = ?",
      whereArgs: [id],
    );

    return await db.delete(
      "contacts",
      where: "id = ?",
      whereArgs: [id],
    );
  }
  // Update contact
  Future<int> updateContact(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row["id"];
    return await db.update(
      "contacts",
      row,
      where: "id = ?",
      whereArgs: [id],
    );
  }


  // create call history
  Future<int> insertCallHistory(int contactId, String date) async {
    Database db = await instance.database;
    return await db.insert("call_history", {
      "contact_id": contactId,
      "call_date": date,
    });
  }
  //Get Call history
  Future<List<Map<String, dynamic>>> getCallHistory() async {
    Database db = await instance.database;
    return await db.rawQuery('''
      SELECT contacts.name, contacts.phone_number, contacts.image, call_history.call_date
      FROM call_history
      JOIN contacts ON contacts.id = call_history.contact_id
      ORDER BY call_history.call_date DESC
    ''');
  }

}
