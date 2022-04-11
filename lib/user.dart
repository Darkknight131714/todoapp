import 'package:flutter/cupertino.dart';

class Useri extends ChangeNotifier {
  String email;
  bool isUrgent = false;
  Useri({required this.email});
  void changeUser(String emaili) {
    email = emaili;
    notifyListeners();
  }

  void changeUrgent() {
    isUrgent = !isUrgent;
    print(isUrgent);
    notifyListeners();
  }
}
