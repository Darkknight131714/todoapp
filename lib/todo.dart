import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/user.dart';
import 'main.dart';

class Todo extends StatefulWidget {
  VoidCallback logout;
  Todo({required this.logout});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (temp == true) {
                  temp = false;
                }
                widget.logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(Provider.of<Useri>(context).email)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Dismissible(
                    key: Key(snapshot.data!.docs[index]['task']),
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.delete),
                            Icon(Icons.delete),
                          ],
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      await snapshot.data!.docs[index].reference.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.grey,
                          content: Text(
                            "Task Done 🥳",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: IconButton(
                            onPressed: () {
                              snapshot.data!.docs[index].reference.update({
                                'isDone': !snapshot.data!.docs[index]['isDone']
                              });
                            },
                            icon: snapshot.data!.docs[index]['isDone']
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.circle_outlined,
                                    color: Colors.purple,
                                    size: 30,
                                  )),
                        title: Text(
                          snapshot.data!.docs[index]['task'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              decoration: snapshot.data!.docs[index]['isDone']
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
