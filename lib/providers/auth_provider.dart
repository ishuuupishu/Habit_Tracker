import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // 🔹 Register User
  Future<String?> registerUser({
    required String email,
    required String password,
    required String displayName,
    String? gender,
    Map<String, dynamic>? otherDetails,
  }) async {
    try {
      // ✅ Create User in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        String userId = user.uid;

        // ✅ Update display name in Firebase Auth profile
        await user.updateDisplayName(displayName);

        // ✅ Save user data in Firestore
        await _firestore.collection('users').doc(userId).set({
          'uid': userId,
          'displayName': displayName,
          'email': email,
          'gender': gender ?? '',
          'otherDetails': (otherDetails != null &&
              otherDetails is Map<String, dynamic>)
              ? otherDetails
              : {},
          'createdAt': FieldValue.serverTimestamp(),
        });

        notifyListeners();
        return null; // success
      }
      return "Unknown error: User is null";
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ FirebaseAuth error: ${e.message}");
      return e.message;
    } catch (e) {
      debugPrint("❌ Unknown error (register): $e");
      return "An unexpected error occurred: $e";
    }
  }

  // 🔹 Login User
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null; // success
    }  on FirebaseAuthException catch (e) {
      debugPrint("❌ FirebaseAuth error: ${e.code} - ${e.message}");
      return e.message ?? e.code;
    } catch (e) {
      debugPrint("❌ Unknown error (login): $e");
      return "An unexpected error occurred: $e";
    }
  }

  // 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  // 🔹 Listen to auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}