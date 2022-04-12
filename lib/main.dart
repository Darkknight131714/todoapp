import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/functions.dart';
import 'package:todo/register.dart';
import 'package:todo/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

bool temp = false;
late BuildContext _t;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String email = "", password = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idk();
  }

  Future idk() async {
    if (FirebaseAuth.instance.currentUser != null) {
      temp = true;
      email = FirebaseAuth.instance.currentUser!.email.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    _t = context;
    return temp
        ? ChangeNotifierProvider<Useri>(
            create: (context) => Useri(email: email),
            child: Home(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: CircleAvatar(
                        radius: 75,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image(
                            image: AssetImage('images/clear.png'),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Welcome Back!',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Email",
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Password",
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                        String val = await login(email, password);
                        if (val == "true") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ChangeNotifierProvider<Useri>(
                                create: (context) => Useri(email: email),
                                child: Home(),
                              );
                            }),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(val),
                            ),
                          );
                        }
                      },
                      child: Text("Login"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont have an account?",
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return RegisterScreen();
                              }),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style:
                                TextStyle(fontSize: 18, color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
