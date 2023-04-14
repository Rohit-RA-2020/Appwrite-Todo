import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/services/auth.dart';

import '../widgets/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool isSignUp = false;

  final authService = AuthService();

  void submit() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (isSignUp) {
        await authService.signUp(
          name: _nameController.text,
          email: _emailController.text,
          password: _passController.text,
        );
        _nameController.clear();
        _emailController.clear();
        _passController.clear();
        setState(() {
          isSignUp = false;
        });
      } else {
        await authService.login(
          email: _emailController.text,
          password: _passController.text,
        );
        _emailController.clear();
        _passController.clear();
      }
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(myOwnSnackBar(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(size: 80),
                  const SizedBox(width: 20),
                  SvgPicture.asset(
                    'assets/appwrite.svg',
                    height: 80,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                isSignUp ? 'Sign Up' : 'Log In',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isSignUp)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                onFieldSubmitted: (value) {
                  submit();
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  isSignUp ? 'Sign Up' : 'Log In',
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isSignUp
                          ? 'Already have an Account ? '
                          : "Don't have an account ? ",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSignUp = !isSignUp;
                          });
                        },
                        child: Text(
                          isSignUp ? ' Login' : ' Sign Up',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
