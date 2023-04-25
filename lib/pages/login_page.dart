import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_la/componets/my_textfield.dart';
import 'package:project_la/componets/my_button.dart';
import 'package:project_la/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  final Function() onTap;
  const LoginPage({Key key, this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // Sign user in
  void signUserin() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    void WrongEmailMessage() {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Incorrect Email'),
          );
        },
      );
    }

    void WrongPassWordMessage() {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Incorrect Password'),
          );
        },
      );
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        WrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        WrongPassWordMessage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 246, 246, 246),
          body: SafeArea(
              child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  //Icon
                  const Icon(
                    Icons.gps_fixed_outlined,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  //Welcome Text
                  const Text(
                    "Hello, Welcome to TapMap",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 50),
                  //Email text field
                  MyTextField(
                    controller: emailController,
                    hinttext: "Email",
                    obscuretext: false,
                  ),

                  const SizedBox(height: 15),
                  // Password text field
                  MyTextField(
                    controller: passwordController,
                    hinttext: "password",
                    obscuretext: true,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 250,
                      ),
                      Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  MyButton(
                    onTap: signUserin,
                    text: "Sign In",
                  ),
                  const SizedBox(height: 275),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a Member?"),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Join us",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ))),
    );
  }
}
