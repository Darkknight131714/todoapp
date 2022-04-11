import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/user.dart';
import 'main.dart';

class Urgent extends StatefulWidget {
  VoidCallback logout;
  Urgent({required this.logout});

  @override
  State<Urgent> createState() => _UrgentState();
}

class _UrgentState extends State<Urgent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Urgent Tasks"),
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
            .where('isUrgent', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Text("No Urgent Tasks Left 🥳"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(snapshot.data!.docs[index]['task']),
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.delete),
                        Icon(Icons.delete),
                      ],
                    ),
                  ),
                  onDismissed: (direction) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text("Task Done 🥳"),
                      ),
                    );
                    await snapshot.data!.docs[index].reference.delete();
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
