import 'package:flutter/material.dart';

import 'package:todo_list/app/repositories/todos_repository.dart';

class HomeController extends ChangeNotifier {
  final TodosRepository repository;
  int selectedTab = 1;

  HomeController({
    @required this.repository,
  });

  void changeSelectedTab(index) {
    selectedTab = index;
    notifyListeners();
  }
}
