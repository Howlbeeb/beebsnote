// ignore_for_file: use_build_context_synchronously

import 'package:beebnotes/constants/routes.dart';
import 'package:beebnotes/constants/styles.dart';
import 'package:beebnotes/services/auth/auth_exceptions.dart';
import 'package:beebnotes/services/auth/auth_service.dart';
import 'package:beebnotes/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/Frame 25.png'),
              const SizedBox(height: 27),
              const Text('Welcome to NoteTab', style: kBigTextStyle),
              const SizedBox(height: 25),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 17, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Image.asset('images/devicon_google.png'),
                      const SizedBox(
                        width: 31,
                      ),
                      const Text('Sign up with Google', style: kSmallTextStyle)
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.8,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF7E7E7E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  const Text('Or', style: kSmallTextStyle),
                  const SizedBox(
                    width: 11,
                  ),
                  Container(
                    width: 150,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.8,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF7E7E7E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              TextField(
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                decoration: const InputDecoration(
                    hintText: 'Email address',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _password,
                decoration: const InputDecoration(
                    hintText: 'Password',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
              ),
              const SizedBox(
                height: 31,
              ),
              ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on InvalidEmailAuthException {
                    await showErrorDialog(
                      context,
                      'Invalid Email',
                    );
                  } on EmailAlreadyInUseAuthException {
                    await showErrorDialog(
                      context,
                      'Email already taken',
                    );
                  } on WeakPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Weak Password ',
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Failed to register',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 17,
                    horizontal: 124,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFF004ADD),
                ),
                child: const Text(
                  'Sign up',
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, loginRoute, (route) => false);
                  },
                  child: const Text(
                    'Already registered? Login',
                    style: kSmallTextStyle,
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
