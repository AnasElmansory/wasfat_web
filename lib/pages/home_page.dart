import 'package:flutter/material.dart';
import 'package:wasfat_web/pages/category_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: const Text('wasfat pannel'),
        centerTitle: true,
      ),
      body: CategoryPage(),
    );
  }
}
