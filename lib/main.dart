import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in.dart';
import 'todo_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(

    /* Change notifier  */
    create: (context) => TodoListProvider(),
    child: const MyApp(),
  )

  );
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MaterialApp(
      title: 'My ToDo List',
      theme: ThemeData(
        //primarySwatch: Colors.blue,

        brightness:  Brightness.light,
        appBarTheme: AppBarTheme(
          color: Colors.indigo, // Set the app bar color to red
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SignIn(),
    );
  }
}
