import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import '../Model/UserModel.dart';
import '../Controller/AuthController.dart';
import '../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseFirestore.instance.terminate();
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: false,
  );
  await FirebaseFirestore.instance.clearPersistence();
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
  final nicknameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: Color.fromRGBO(232, 215, 199, 1),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(174, 221, 239, 1),
              title: const Text('auth'),
            ),
            body: Form(
                key: _key,
                child: Center(
                  child: Column(
                    children: [
                      TextFormField(
                          controller: emailController,
                          validator: validateEmail),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: validatePassword,
                      ),
                      TextFormField(
                        controller: nicknameController,
                        validator: validateNickname,
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
                                            password: passwordController.text)
                                        .then((value) => createUser(UserModel(
                                              uid: (value.user?.uid).toString(),
                                              nickname: nicknameController.text,
                                              userpic:
                                                  'https://tp.parenting.com.tw/images/user-cover.jpg',
                                              admin: false,
                                            )));
                                    user = FirebaseAuth.instance.currentUser;

                                    errorMessage = '';
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/community',
                                            (Route<dynamic> route) => false);
                                  } on FirebaseAuthException catch (error) {
                                    // error.message!
                                    errorMessage = '????????????????????????~';
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
                                    user = FirebaseAuth.instance.currentUser;

                                    Navigator.of(context)
                                        .pushReplacementNamed('/community');
                                  } on FirebaseAuthException catch (error) {
                                    switch (error.code) {
                                      case "user-not-found":
                                        errorMessage = "?????????????????????";
                                        break;
                                      case "wrong-password":
                                        errorMessage = "????????????";
                                        break;
                                    }

                                    // etc
                                    // errorMessage = error.message!;
                                  }
                                  setState(() {});
                                }
                              },
                              child: const Text('Sign in')),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        );
      },
      maximumSize: Size(475.0, 812.0), // Maximum size
      enabled: kIsWeb, // default is enable, when disable content is full size
      backgroundColor:
          Color.fromRGBO(232, 215, 199, 0.5), // Background color/white space
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) return '??????????????????';

  String pattern = r'\w+@\w+\.\w';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return '?????????????????????';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) return '??????????????????';

  // String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
  // RegExp regex = RegExp(pattern);
  // if (!regex.hasMatch(formPassword)) return '???????????????8???????????????????????????????????????';

  return null;
}

String? validateNickname(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) return '???????????????(??????)';

  // String pattern = r'[a-z]';
  // RegExp regex = RegExp(pattern);
  // if (!regex.hasMatch(formEmail)) return '????????????';

  return null;
}
