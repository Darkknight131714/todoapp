import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> login(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return "true";
  } catch (e) {
    return e.toString();
  }
}

Future<String> signUp(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return "true";
  } catch (e) {
    return e.toString();
  }
}

Future<void> addTask(String email, String task, bool isUrgent) async {
  await FirebaseFirestore.instance.collection(email).add({
    'task': task,
    'time': Timestamp.now(),
    'isUrgent': isUrgent,
    'isDone': false
  });
}
