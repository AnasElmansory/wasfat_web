import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_web/models/user.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  WasfatUser? wasfatUser;

  Auth(
    this._firebaseAuth,
    this._firestore,
  );

  Future<bool> isLoggedIn() async {
    final shared = await SharedPreferences.getInstance();
    final _isLoggedIn = shared.getBool('isLoggedIn') ?? false;
    final isUser = _firebaseAuth.currentUser != null;
    if (_isLoggedIn && isUser)
      return true;
    else
      return false;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    final shared = await SharedPreferences.getInstance();
    await shared.setBool('isLoggedIn', false);
    wasfatUser = null;
    notifyListeners();
  }

  Future<void> getUserData() async {
    if (await isLoggedIn()) {
      final query = await _firestore
          .collection('admins')
          .where('id', isEqualTo: _firebaseAuth.currentUser?.uid)
          .get();

      if (query.docs.isNotEmpty) {
        final user = query.docs.single.data();
        wasfatUser = WasfatUser(
          uid: user['id'],
          name: user['name'],
          email: user['email'],
          photoURL: user['photoURL'],
        );
      }
      notifyListeners();
    }
  }

  Future<WasfatUser?> checkAdminPermission(String userId) async {
    final query = await _firestore
        .collection('admins')
        .where('id', isEqualTo: userId)
        .get();
    if (query.docs.isNotEmpty) {
      final admin = query.docs.single.data();
      wasfatUser = WasfatUser(
        uid: admin['id'],
        name: admin['name'],
        email: admin['email'],
        photoURL: admin['photoURL'],
      );
      return wasfatUser;
    } else
      return null;
  }

  Future<void> signInWithGoogle() async {
    final shared = await SharedPreferences.getInstance();
    final userCredential =
        await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
    final isUser = userCredential.user != null;
    if (isUser) {
      await shared.setBool('isLoggedIn', true);
      final admin = await checkAdminPermission(userCredential.user!.uid);
      wasfatUser = admin;
    }
  }
}
