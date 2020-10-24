import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/app/database/connection.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  // WidgetsBindingObserver => usado pra observar o status do app
  // precisa ser StatefulWidget pra isso!

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // chamado sempre que o estado do app for alterado
    var connection = Connection();
    switch (state) {
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.inactive:
        connection.closeConnection();
        break;
      case AppLifecycleState.paused:
        connection.closeConnection();
        break;
      case AppLifecycleState.detached:
        connection.closeConnection();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primaryColor: Color(0xFFFF9129),
        buttonColor: Color(0xFFFF9129),
        textTheme: GoogleFonts.robotoTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
        ),
        body: Container(),
      ),
    );
  }
}
