import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier{
  final _controller = PageController();
  PageController get controller => this._controller;
  
  int _currentPage = 0;

  int get currentPage => this._currentPage;

 set currentPage(int value) {
    this._currentPage = value;
    notifyListeners();
 }


  Future<void> toPage(int page)async{
  currentPage = page;
  await _controller.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeIn,);
  
  }



  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();}
}