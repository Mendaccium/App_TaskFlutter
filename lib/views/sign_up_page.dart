import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app/authentication_service.dart';

class SignUpPage extends StatefulWidget{


  @override
  _SignUpPageState createState() => _SignUpPageState();


 

}

class _SignUpPageState extends State<SignUpPage>{
  final _key = GlobalKey<FormState>();

  final AuthenticationService _auth = AuthenticationService();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Form(
            key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Registro",
               style: TextStyle(
                 color: Colors.blue,
                 fontSize: 32,
                 fontWeight: FontWeight.w600,
               ),
              ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Nome não pode ser vazio";
                      }else
                        return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Email não pode ser vazio";
                      }else
                        return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.black)),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: passwordController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Senha não pode ser vazia";
                      }else
                        return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Senha",
                      labelStyle: TextStyle(color: Colors.black)),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                        if (_key.currentState!.validate() ) {
                          SignUp();
                        } 
                      },
                        child: Text('Registrar'),
                        color: Colors.blue,
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, 
                        child: Text('Cancelar'),
                        color: Colors.blue,
                        )
                    ],
                  )
                ],
              ),
              ),
            ],
          ),

          ),
        ),
      ),
    );
  }

  void SignUp() async{
    dynamic result = await _auth.signUp(emailController.text, passwordController.text);
    if(result==null){
      print("Email não é valido");
    }else{
      print(result.toString());
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      Navigator.pop(context);
    
    }
  }
}