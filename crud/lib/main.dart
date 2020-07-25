import 'package:crud/provider/users.dart';
import 'package:crud/routes/app_routes.dart';
import 'package:crud/views/user_form.dart';
import 'package:crud/views/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Users(),
      child: MaterialApp(
          title: 'CRUD',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Colors.red,
            brightness: Brightness.light,
          ),
          // home: UserList(),
          routes: {
            AppRoutes.HOME: (context) => UserList(),
            
            AppRoutes.USER_FORM: (context) => UserForm(),
          }),
    );
  }
}
