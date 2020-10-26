import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/new_task/new_task_controller.dart';
import 'package:todo_list/app/shared/time_component.dart';

class NewTaskPage extends StatefulWidget {
  static String routerName = '/new';

  const NewTaskPage({Key key}) : super(key: key);

  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // aqui dentro posso usar o context sem problemas
      // context.read<NewTaskController>().addListener(() {
      Provider.of<NewTaskController>(context, listen: false).addListener(() {
        // var controller = context.read<NewTaskController>();
        var controller = Provider.of<NewTaskController>(context, listen: false);

        if (controller.error != null) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(controller.error),
          ));
        }

        if (controller.saved) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Todo cadastrado com sucesso'),
          ));
          Future.delayed(Duration(seconds: 1), () => Navigator.pop(context));
        }
      });
    });
  }

  @override
  void dispose() {
    // context.read<NewTaskController>().removeListener(() {});
    Provider.of<NewTaskController>(context, listen: false)
        .removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTaskController>(
      builder: (BuildContext context, controller, _) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOVA TASK',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Data',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.dayFormated,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Nome da Task',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.nomeTaskController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Nome da task obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Hora',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TimeComponent(
                        date: controller.daySelected,
                        onSelectedTime: (date) {
                          controller.daySelected = date;
                        }),
                    SizedBox(
                      height: 50,
                    ),
                    _buildButton(controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(NewTaskController controller) {
    return Center(
      child: InkWell(
        onTap: () => !controller.saved ? controller.save() : null,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.decelerate,
          width: controller.saved ? 80 : MediaQuery.of(context).size.width,
          height: controller.saved ? 80 : 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: controller.saved
                ? BorderRadius.circular(100)
                : BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 2),
                color: Theme.of(context).primaryColor,
                blurRadius: controller.saved ? 30 : 1,
              ),
              // controller.saved
              //     ? BoxShadow(
              //         offset: Offset(2, 2),
              //         blurRadius: 30,
              //         color: Theme.of(context).primaryColor,
              //       )
              //     : BoxShadow(
              //         offset: Offset(2, 2),
              //         blurRadius: 1,
              //         color: Theme.of(context).primaryColor,
              //       ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: !controller.saved ? 0 : 80,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInBack,
                  opacity: !controller.saved ? 0 : 1,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
              Visibility(
                visible: !controller.saved,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
