import 'dart:developer';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? db;
  static Future<void> createDB() async {
    String path = "${await getDatabasesPath()}mapMarkers.db";
    db = await openDatabase(path, version: 8, onCreate: (db, version) async {
      await db.execute('PRAGMA foreign_keys = ON');
      await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
      ''');
      await db.execute('''
      CREATE TABLE mapMarkers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        longitude REAL,
        latitude REAL, 
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
      ''');
    });
  }

  static Future<int?> signUp(String email, String password) async {
    try {
      return await db?.insert('users', {'email': email, 'password': password});
    } catch (e) {
      log("Signup error: $e");
      return null;
    }
  }

  static Future<bool> validateLogin(String email, String password) async {
    try {
      final result = await db?.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (result != null && result.isNotEmpty) {
        int userId = result.first['id'] as int;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userId);

        log(userId.toString());
        log(prefs.getInt('user_id').toString());

        return true;
      }
      return false;
    } catch (e) {
      log("Error in login: $e");
      return false;
    }
  }

  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  /*static Future<void> setUserId(int userId) async {
    var userID = await db?.query('users', where: 'id = ?', whereArgs: [userId]);
  }*/

  /* static Future<Map<String, dynamic>?> getUserId() async {
    try {
      final result = await db?.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result?.isNotEmpty == true ? result!.first : null;
    } catch (e) {
      log("Error getting user by ID: $e");
      return null;
    }
  }*/

  /*static Future<int?> startNewRoute(int userId) async {
    try {
      return await db?.insert("ro", {
        'user_id': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      log("Error creating new route: $e");
      return null;
    }
  }*/

  static Future<void> addLocation(double latitude, double longitude) async {
    try {
      int? userId = await getUserId();
      await db?.insert("mapMarkers", {
        'latitude': latitude,
        'longitude': longitude,
        'user_id': userId,
      });
    } catch (e) {
      log("Error saving location: $e");
    }
  }

  static Future<List<LatLng>> getLocations() async {
    try {
      int? userId = await getUserId();
      final results = await db!.query(
        'mapMarkers',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      return results
          .map((marker) => LatLng(
                marker['latitude'] as double,
                marker['longitude'] as double,
              ))
          .toList();
    } catch (e) {
      log("Error loading locations: $e");
      throw Exception("Failed to load locations");
    }
  }

  /* static Future<List<LatLng>> getLocations() async {
    int? userId = await getUserId();
    if (userId == null) {
      log("User ID not found");
      return [];
    }

    try {
      final result = await db!.query(
        'mapMarkers',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      if (result.isEmpty) {
        log("No routes found for the user");
        return [];
      }

      return result
          .map((marker) => LatLng(
                marker['latitude'] as double,
                marker['longitude'] as double,
              ))
          .toList();
    } catch (e) {
      log("Error loading locations: $e");
      throw Exception("Failed to load locations");
    }
  }*/

/*
  static Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      final result = await db?.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result?.isNotEmpty == true ? result!.first : null;
    } catch (e) {
      log("Error getting user by ID: $e");
      return null;
    }
  }*/

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final result = await db?.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      return result?.isNotEmpty == true ? result!.first : null;
    } catch (e) {
      log("Error getting user: $e");
      return null;
    }
  }

  void signOut() {
    db?.close();
    db = null;
  }
}
