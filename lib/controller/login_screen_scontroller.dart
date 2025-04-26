import 'package:flutter/material.dart';

class LoginScreenController with ChangeNotifier {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
}
