import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/functions.dart';
import 'package:todo/main.dart';
import 'package:todo/todo.dart';
import 'package:todo/urgent.dart';
import "package:persistent_bottom_nav_bar/persistent-tab-view.dart";
import 'package:todo/user.dart';

late BuildContext contexti;
String task = "";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> screen = [];
  int curr = 0;
  bool isUrgent = false;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    screen = [
      Todo(logout: () {
        logout();
      }),
      Container(),
      Urgent(
        logout: () => logout(),
      )
    ];
    _pageController = PageController(initialPage: curr);
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyApp();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    contexti = context;
    return PersistentTabView(
      context,
      screens: screen,
      controller: _controller,
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Colors.orange,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          onPressed: (p0) {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                context: contexti,
                builder: (_) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setMState) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            "Enter Your Task",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintStyle: TextStyle(color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Task",
                              ),
                              onChanged: (value) {
                                task = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Mark Urgency",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: isUrgent ? Colors.green : Colors.red,
                              minimumSize: Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color: Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              setMState(() {
                                isUrgent = !isUrgent;
                              });
                            },
                            child: isUrgent
                                ? Text("Marked as Urgent")
                                : Text("Not Urgent"),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              minimumSize: Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color: Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (task == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.grey,
                                    content: Text(
                                      "Task field cannot be empty",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                );
                                Navigator.pop(contexti);
                                return;
                              }
                              await addTask(
                                  Provider.of<Useri>(contexti, listen: false)
                                      .email,
                                  task,
                                  isUrgent);
                              isUrgent = false;
                              task = "";
                              setMState(() {});
                              Navigator.pop(contexti);
                            },
                            child: Text("Create Task"),
                          ),
                        ],
                      ),
                    );
                  });
                });
          },
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          title: ("Add"),
          activeColorPrimary: Colors.orange,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.emergency),
          title: ("Urgent"),
          activeColorPrimary: Colors.orange,
          inactiveColorPrimary: Colors.grey,
        ),
      ],
      resizeToAvoidBottomInset: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style16,
    );
  }
}
