import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app/authentication_service.dart';
import 'package:task_app/views/home_page.dart';
import 'package:task_app/views/sign_up_page.dart';

class SignInPage extends StatefulWidget{


  @override
  _SignInPageState createState() => _SignInPageState();


 

}

class _SignInPageState extends State<SignInPage>{
  final _key = GlobalKey<FormState>();
  late bool passwordVisible;

  @override
  void initState() {
   passwordVisible = false;
  }

  final AuthenticationService _auth = AuthenticationService();

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
                "App Task",
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
                  SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Email inválido";
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
                  SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Senha inválida";
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
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        onPressed: () {
                        if (_key.currentState!.validate() ) {
                          SignIn();
                        } 
                      },
                        child: Text('Login'),
                        color: Colors.blue,
                      ),
                      SizedBox(height: 5),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => SignUpPage())
                          );
                          
                        }, 
                        child: const Text('Registre-se'),
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

  void SignIn() async{
    String result = await _auth.signIn(emailController.text, passwordController.text) as String;
    print(result);
    if(result!="Signed in"){
      print("Login inválido");
      emailController.clear();
      passwordController.clear();
    }else{
      print(result.toString());
      emailController.clear();
      passwordController.clear();
      Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
            HomePage()), (Route<dynamic> route) => false
      );
    
    }
  }

  void changePasswordVisible(){
    passwordVisible = !passwordVisible;
  }
}

