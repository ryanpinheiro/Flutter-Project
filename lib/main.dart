import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/Telas/Cadastro.dart';
import 'package:untitled/Telas/Home..dart';
import 'package:untitled/Telas/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Firebase',
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => LoginScreen(),
        '/Cadastro': (context) => RegisterScreen(),
        '/Home': (context) => HomeScreen(),
      },
    );
  }
}
