import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


   Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }


  Future signIn(String email, String password) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in"; 
    }on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print("Email ou senha inválidos");
      // ignore: avoid_print
      print(e.message) ;
      return "Error";
    }
  }

  Future<String?> signUp(String email, String password)async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up"; 
    }on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print("Email ou senha inválidos");
      // ignore: avoid_print
      print(e.message);
    }
  }
}