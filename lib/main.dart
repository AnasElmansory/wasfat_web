import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_web/app.dart';
import 'package:wasfat_web/d_injection.dart';

void main() async {
  await Firebase.initializeApp();
  getInit();
  runApp(const App());
}
