import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_la/pages/login_page.dart';
import 'package:project_la/pages/register_page.dart';

class RegisterOrLogin extends StatefulWidget {
  const RegisterOrLogin({Key key}) : super(key: key);

  @override
  State<RegisterOrLogin> createState() => _RegisterOrLogin();
}

class _RegisterOrLogin extends State<RegisterOrLogin> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage == true) {
      return LoginPage(
        onTap: togglePage,
      );
    } else {
      return RegisterPage(
        onTap: togglePage,
      );
    }
  }
}
