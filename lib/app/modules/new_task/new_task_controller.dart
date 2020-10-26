import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todo_list/app/repositories/todos_repository.dart';

class NewTaskController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('dd/MM/yyyy');
  final TodosRepository repository;
  DateTime daySelected;
  TextEditingController nomeTaskController = TextEditingController();
  bool saved = false;
  bool loading = false;
  String error;

  NewTaskController({this.repository, String day}) {
    daySelected = dateFormat.parse(day);
  }

  String get dayFormated => dateFormat.format(daySelected);

  Future<void> save() async {
    try {
      if (formKey.currentState.validate()) {
        loading = true;
        saved = false;
        await repository.saveTodo(daySelected, nomeTaskController.text);
        saved = true;
        loading = false;
      }
    } on Exception catch (e) {
      print(e);
      error = 'Erro ao salvar todo';
    }
    notifyListeners();
  }
}
