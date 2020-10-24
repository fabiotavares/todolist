import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Atividades'),
          ),
          body: Container(
            child: FlatButton(
              onPressed: () => Navigator.of(context).pushNamed('/new'),
              child: Text('Mudar nome'),
            ),
          ),
        );
      },
    );
  }
}
