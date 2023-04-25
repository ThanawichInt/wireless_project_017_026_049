import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_la/componets/my_textfield.dart';
import 'package:project_la/componets/my_button.dart';
import 'package:project_la/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onTap;
  const RegisterPage({Key key, this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // Sign user up
  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    void showErrorMessage(String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Center(
            child: Text(message),
          ));
        },
      );
    }

    try {
      if (passwordController.text == confirmpasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        showErrorMessage("Password did not match@");
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
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
                    "Creating an Account!",
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
                  const SizedBox(height: 15),
                  // Password text field
                  MyTextField(
                    controller: confirmpasswordController,
                    hinttext: "confirm password",
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
                    onTap: signUserUp,
                    text: "Sign Up",
                  ),
                  const SizedBox(height: 200),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
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
