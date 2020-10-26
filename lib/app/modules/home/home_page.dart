import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/new_task/new_task_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Atividades',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: FFNavigationBar(
            selectedIndex: controller.selectedTab,
            theme: FFNavigationBarTheme(
              itemWidth: 60,
              barHeight: 70,
              barBackgroundColor: Theme.of(context).primaryColor,
              unselectedItemIconColor: Colors.white,
              unselectedItemLabelColor: Colors.white,
              selectedItemBorderColor: Colors.white,
              selectedItemIconColor: Colors.white,
              selectedItemBackgroundColor: Theme.of(context).primaryColor,
              selectedItemLabelColor: Colors.black,
            ),
            items: [
              FFNavigationBarItem(
                iconData: Icons.check_circle,
                label: 'Finalizados',
              ),
              FFNavigationBarItem(
                iconData: Icons.view_week,
                label: 'Semanal',
              ),
              FFNavigationBarItem(
                iconData: Icons.calendar_today,
                label: 'Selecionar Data',
              ),
            ],
            onSelectTab: (index) {
              controller.changeSelectedTab(context, index);
            },
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: controller.listTodos?.keys?.length ?? 0,
              itemBuilder: (_, int index) {
                // obtendo a data e sua respectiva lista de todos
                var dateFormat = DateFormat('dd/MM/yyyy');
                // Iterable precisa usar elementAt
                var listTodos = controller.listTodos;
                var dayKey = listTodos.keys.elementAt(index);
                var todos = listTodos[dayKey];

                // se está na tab dos finalizados e não tem tarefas...
                if (todos.isEmpty && controller.selectedTab == 0) {
                  // ...retorne um SizedBox menor possível
                  return SizedBox.shrink();
                }

                // descobrindo se uso Hoje, Amanhã ou a data propriamente
                var day = dayKey;
                var hoje = DateTime.now();
                var amanha = hoje.add(Duration(days: 1));
                if (dayKey == dateFormat.format(hoje)) {
                  day = 'HOJE';
                } else if (dayKey == dateFormat.format(amanha)) {
                  day = 'AMANHÃ';
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              await Navigator.of(context).pushNamed(
                                NewTaskPage.routerName,
                                arguments: dayKey,
                              );
                              // atualizar tasks
                              controller.update();
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      // diz que a lista de cima controla o tamanho desta
                      shrinkWrap: true,
                      // impede a rolagem para não impedir na lista de cima
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: todos.length,
                      itemBuilder: (_, int index) {
                        var todo = todos[index];
                        return Dismissible(
                          key: ValueKey(todo.id),
                          direction: DismissDirection.endToStart,
                          background: backgroundDelete(context),
                          confirmDismiss: (_) => confirmDeleteDialog(context),
                          onDismissed: (_) => controller.deleteTodo(todo),
                          child: ListTile(
                            leading: Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              value: todo.finalizado,
                              onChanged: (value) =>
                                  controller.checkOrUncheck(todo),
                            ),
                            title: Text(
                              todo.descricao,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                decoration: todo.finalizado
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Text(
                              '${todo.dataHora.hour.toString().padLeft(2, '0')}:${todo.dataHora.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                decoration: todo.finalizado
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Container backgroundDelete(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Excluir",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Future<bool> confirmDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Tem certeza?'),
        content: Text('Deseja excluir essa tarefa?'),
        actions: [
          FlatButton(
            child: Text('Não'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text('Sim'),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
