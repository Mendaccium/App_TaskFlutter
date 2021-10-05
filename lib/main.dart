// ignore_for_file: use_key_in_widget_constructors


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/authentication_service.dart';
import 'package:task_app/views/home_page.dart';
import 'package:task_app/views/sign_in_page.dart';


void main() async {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
 

   const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<AuthenticationService>(
        create:(_)=>AuthenticationService(),
      ),
      StreamProvider(
        create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
        ),
    ],
    child: MaterialApp(
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SignInPage(),
      routes: {
        HomePage.tag: (context) => const HomePage(),
      },
    ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    
    if(firebaseUser != null){
      return const HomePage();
    }
    return SignInPage();
  }
}


