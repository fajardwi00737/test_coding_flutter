import 'package:flutter/material.dart';
import 'package:test_live_code/screen/home_navigation.dart';
import 'package:test_live_code/screen/initia_page.dart';
import 'package:test_live_code/screen/login_page.dart';
import 'package:test_live_code/screen/register_page.dart';
import 'package:test_live_code/screen/todo_list_page.dart';
import 'package:test_live_code/screen/todo_list_update.dart';
import 'package:test_live_code/utils/general_sharedpreference.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setUpApp();
  runApp(MyApp());
}

Future<void> setUpApp()async{
  await GeneralSharedPreferences.setUp();
}

final routes = {
  '/login': (BuildContext context) => new LoginPage(),
  '/home': (BuildContext context) => new HomeNavigation(),
  '/register': (BuildContext context) => new RegisterPage(),
  '/todo_list_update': (BuildContext context) => new TodoListUpdate(),
  '/todo_list_page': (BuildContext context) => new TodoListPage(),
  '/': (BuildContext context) => new InitialPage(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Coding Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}