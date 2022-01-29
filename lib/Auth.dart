import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Auth());
}

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('auth (Logged' + (user == null ? 'out' : 'in') + ')'),
        ),
        body: Form(
            key: _key,
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                      controller: emailController, validator: validateEmail),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  Center(
                    child: Text(errorMessage),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);

                                errorMessage = '';
                              } on FirebaseAuthException catch (error) {
                                // error.message!
                                errorMessage = '此信箱已被註冊過~';
                              }
                              setState(() {});
                            }
                          },
                          child: Text('Sign up')),
                      ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                errorMessage = '';
                                Navigator.of(context).pushReplacementNamed('/upload');
                              } on FirebaseAuthException catch (error) {
                                switch (error.code){
                                  case "user-not-found":
                                    errorMessage = "此用戶尚未註冊";
                                    break;
                                  case "wrong-password":
                                    errorMessage = "密碼錯誤";
                                    break;
                                }

                                    // etc
                                // errorMessage = error.message!;
                              }
                              setState(() {});
                            }
                          },
                          child: Text('Sign in')),

                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) return '請記得填信箱';

  String pattern = r'\w+@\w+\.\w';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return '錯誤的信箱格式';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) return '請記得填密碼';

  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) return '密碼至少需8位，且包含大小寫英文及數字';

  return null;
}
