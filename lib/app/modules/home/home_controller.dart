import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/models/todo_model.dart';
import 'package:collection/collection.dart';
import 'package:todo_list/app/repositories/todos_repository.dart';

class HomeController extends ChangeNotifier {
  final TodosRepository repository;
  DateTime daySelected;
  DateTime startFilter;
  DateTime endFilter;
  Map<String, List<TodoModel>> listTodos;
  var dateFormat = DateFormat('dd/MM/yyyy');
  int selectedTab = 1;

  HomeController({@required this.repository}) {
    // busca a lista já no construtor
    // repository.saveTodo(DateTime.now().subtract(Duration(days: 1)), 'Teste5');
    // repository.saveTodo(DateTime.now().subtract(Duration(days: 2)), 'Teste6');
    findAllForWeek();
  }

  Future<void> findAllForWeek() async {
    daySelected = DateTime.now();

    // descobrindo primeiro e último dias da semana corrente
    startFilter = DateTime.now();
    if (startFilter.weekday != DateTime.monday) {
      startFilter =
          startFilter.subtract(Duration(days: startFilter.weekday - 1));
    }
    endFilter = startFilter.add(Duration(days: 6));

    // buscando os todos da semana
    var todos = await repository.findByPeriod(startFilter, endFilter);
    if (todos.isEmpty) {
      // garante pelo menos um elemento na lista a ser exibida
      listTodos = {dateFormat.format(DateTime.now()): []};
    } else {
      // obtendo a lista de todos agrupados por data
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.dataHora));
    }

    notifyListeners();
  }

  Future<void> findTodosBySelectedDay() async {
    var todos = await repository.findByPeriod(daySelected, daySelected);
    if (todos.isEmpty) {
      // garante pelo menos um elemento na lista a ser exibida
      listTodos = {dateFormat.format(daySelected): []};
    } else {
      // obtendo a lista de todos agrupados por data
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.dataHora));
    }

    notifyListeners();
  }

  Future<void> changeSelectedTab(BuildContext context, int index) async {
    selectedTab = index;
    switch (index) {
      case 0:
        filterFinalizados();
        break;
      case 1:
        findAllForWeek();
        break;
      case 2:
        var day = await showDatePicker(
          context: context,
          initialDate: daySelected,
          firstDate: DateTime.now().subtract(Duration(days: (360 * 3))),
          lastDate: DateTime.now().add(Duration(days: (360 * 10))),
        );
        if (day != null) {
          daySelected = day;
          findTodosBySelectedDay();
        }
        break;
    }
    notifyListeners();
  }

  void checkOrUncheck(TodoModel todo) {
    todo.finalizado = !todo.finalizado;
    notifyListeners();
    // não preciso ficar esperando atualizar o banco de dados
    repository.checkOrUncheckTodo(todo);
  }

  void filterFinalizados() {
    listTodos = listTodos.map((key, value) {
      var todosFinalizados = value.where((t) => t.finalizado).toList();
      return MapEntry(key, todosFinalizados);
    });
    notifyListeners();
  }

  void update() {
    if (selectedTab == 1) {
      this.findAllForWeek();
    } else if (selectedTab == 2) {
      this.findTodosBySelectedDay();
    }
  }

  void deleteTodo(TodoModel todo) {
    // remove o todo da lista...
    List<TodoModel> list = listTodos[dateFormat.format(todo.dataHora)];
    list.removeAt(list.indexWhere((t) => t.id == todo.id));
    // remove o todo do banco de dados...
    repository.deleteTodo(todo.id);
  }
}
