import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_web/app_widget.dart';
import 'package:wasfat_web/get_service.dart';

void main() async {
  await Firebase.initializeApp();
  getInit();
  runApp(App());
}
