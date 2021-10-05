
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/authentication_service.dart';
import 'package:task_app/views/sign_in_page.dart';


class HomePage extends StatelessWidget {
  static String tag = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationService _auth = AuthenticationService();
    var snapshots = FirebaseFirestore.instance
      .collection('tarefas')
      .orderBy('data')
      .snapshots();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Task'),
        actions: [
          RaisedButton(
            onPressed: () async{
              await _auth.signOut().then((result){
                Navigator.of(context).push(
                    CupertinoPageRoute(
                    builder: (context) => SignInPage())
                  );
              });
            },
            child: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            color: Colors.blue, 
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      
      body: StreamBuilder(

        stream: snapshots,
        builder : (
          BuildContext context, 
          AsyncSnapshot<QuerySnapshot> snapshot
          ) {
            if(snapshot.hasError){
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator()
              );
            }
            if(snapshot.data!.docs.isEmpty){
              return const Center(
                child: Text('Sem tarefas!')
              );
            }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int i){
              var doc = snapshot.data!.docs[i];
              Map<String, dynamic> item = snapshot.data!.docs[i].data() as Map<String, dynamic>;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ListTile(
                  isThreeLine: true,
                  leading: IconButton(
                    icon: const Icon( 
                      Icons.border_color,
                      size: 32,
                      ),
                    onPressed: () => modalEdit(context, doc)
                    
                    ),
                    title: Text("${item['title']}"),
                    subtitle: Text("${item['description']}"),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.delete), 
                        onPressed: () => doc.reference.delete(),
                      ),
                    ),

                ),
              );
            },
            ); 
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreate(context),
        tooltip: 'Adicionar nova tarefa',
        child: const Icon(Icons.add),
      ),
    
    
      // ignore: deprecated_member_use
      
    

            
      );
    
  }

  modalCreate(BuildContext context){
    var form = GlobalKey<FormState>();
    var title = TextEditingController();
    var description = TextEditingController();

    showDialog(
           context: context,
           builder: (BuildContext context){
             return AlertDialog(
               title: Text('Criar nova tarefa'),
               content: Form(
                 key: form,
                 child: Container(
                   height: MediaQuery.of(context).size.height/3,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Título'),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Ex. Estudar flutter',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                          ),
                        controller: title,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Este campo não pode ser vazio';
                          }
                          return null;                      }
                      ),
                        SizedBox(height: 20,),
                        Text('Descrição'),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '(Opcional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          ),
                         controller: description,
                      ),
                        ],
                      ),
                 ),
                 ),
               actions:<Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  child: Text('Cancelar'),
                 ),
                FlatButton(
                  onPressed: () async{
                    if(form.currentState!.validate()){
                      await FirebaseFirestore.instance.collection('tarefas').add({
                        'title': title.text,
                        'description': description.text,
                        'data': Timestamp.now(),
                        
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  color: Colors.green,
                  child: Text('Salvar'),
                 ),
               ],
               );
           }
           );
  }

  modalEdit(BuildContext context, QueryDocumentSnapshot<Object?> doc){
    var form = GlobalKey<FormState>();
    var title = TextEditingController();
    var description = TextEditingController();

    showDialog(
           context: context,
           builder: (BuildContext context){
             return AlertDialog(
               title: Text('Editar tarefa'),
               content: Form(
                 key: form,
                 child: Container(
                   height: MediaQuery.of(context).size.height/3,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Título'),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Ex: Estudar React-Native',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                          ),
                        controller: title,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Este campo não pode ser vazio';
                          }
                          return null;
                        }
                      ),
                        SizedBox(height: 20,),
                        Text('Descrição'),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '(Opcional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          ),
                         controller: description,
                      ),
                        ],
                      ),
                 ),
                 ),
               actions:<Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  child: Text('Cancelar'),
                 ),
                FlatButton(
                  onPressed: () async{
                    if(form.currentState!.validate()){
                      doc.reference.update({
                        'title': title.text,
                        'description': description.text,
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  color: Colors.green,
                  child: Text('Salvar'),
                 ),
               ],
               );
           }
           );
  }


  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
