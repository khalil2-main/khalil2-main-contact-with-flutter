import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../db/db_helper.dart';

// Auth service handles register / login / logout and keeps the current user.


class AuthService extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  final DBHelper _dbHelper = DBHelper.instance;

  // Try to load user  (by email)
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    if (email != null) {
      final row = await _dbHelper.getUserByEmail(email);
      if (row != null) {
        _user = UserModel.fromMap(row);
        notifyListeners();
      }
    }
  }


  // Register a new user
  // Throws Exception on duplicate email or db error
  Future<UserModel> register({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // Basic validation for sign in
    if (name.trim().length < 1) {
      throw Exception('First name is required.');
    }
    if (lastName.trim().length < 1) {
      throw Exception('Last name is required.');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Enter a valid email address.');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }

    // Prepare user map
    final user = UserModel(
      name: name.trim(),
      lastName: lastName.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );

    // Insert new user into DB
    try {
      final id = await _dbHelper.insertUser(user.toMap());
      final createdUser = UserModel(
        id: id,
        name: user.name,
        lastName: user.lastName,
        email: user.email,
        password: user.password,
      );

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', createdUser.email);

      _user = createdUser;
      notifyListeners();
      return createdUser;
    } catch (e) {
      // if unique constraint violated, sqflite throws DatabaseException
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  /// Login using email + password

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Enter a valid email address.');
    }
    if (password.isEmpty) {
      throw Exception('Password is required.');
    }
    try {
      final row = await _dbHelper.login(email.trim().toLowerCase(), password);
      if (row == null) {
        throw Exception('Invalid email or password.');
      }
      final logged = UserModel.fromMap(row);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', logged.email);

      _user = logged;
      notifyListeners();
      return logged;
    } catch (e) {
      //handle error
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  /// Logout: clear session and current user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    _user = null;
    notifyListeners();
  }
}
