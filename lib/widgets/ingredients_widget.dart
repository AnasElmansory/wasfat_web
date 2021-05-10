import 'package:flutter/material.dart';

class Ingredients extends StatelessWidget {
  final TextEditingController controller;

  const Ingredients({Key key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      height: size.height * 0.2,
      width: size.width * 0.5,
      child: Row(
        children: [
          Expanded(flex: 1, child: const Text('dish ingredients')),
          Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber[800])),
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter dish ingredients',
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
