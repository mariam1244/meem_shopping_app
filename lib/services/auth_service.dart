import 'package:flutter/material.dart';

class AuthService {
  Future<String?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String address,
    required String gender,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Dummy Sign Up successful for $email');
    return 'dummy_user_id';
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Dummy Sign In successful for $email');
    return 'dummy_user_id';
  }

  Future<void> signOut() async {
    debugPrint('Dummy Sign Out successful');
    return;
  }
}
