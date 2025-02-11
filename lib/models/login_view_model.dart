import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:map_meters_marker/models/DataBase.dart';

class LoginControllers {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8;

    // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
  }

  Future<bool> validateLogin() async {
    try {
      if (!isValidEmail(emailController.text) ||
          !isValidPassword(passwordController.text)) {
        return false;
      }

      return await DBHelper.validateLogin(
          emailController.text, passwordController.text);
    } catch (e) {
      log("Login validation error: $e");
      return false;
    }
  }

  Future<int?> validateSignUp() async {
    try {
      final email = emailController.text;
      final password = passwordController.text;

      if (!isValidEmail(email) || !isValidPassword(password)) {
        return null;
      }

      // Check if user already exist
      final existingUser = await DBHelper.getUserByEmail(email);
      if (existingUser != null) {
        return null;
      }

      // Create new user
      await DBHelper.signUp(email, password);
      final newUser = await DBHelper.getUserByEmail(email);
      return newUser?['id'] as int?;
    } catch (e) {
      log("Signup error: $e");
      return null;
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
