// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/signin/signin_cubit.dart';
import 'package:flutter_application/pages/signup_page.dart';
import 'package:flutter_application/utils/error_dialog.dart';
import 'package:validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/pages/home_page.dart';

class SigninPage extends StatefulWidget {
  static const String routeName = '/signin';
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPage();
}

class _SigninPage extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;
  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();

    print('email: $_email, password: $_password');

    context.read<SigninCubit>().signin(email: _email!, password: _password!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SigninCubit, SigninState>(
          listener: (context, state) {
            if (state.signinStatus == SigninStatus.error) {
              errorDialog(context, state.error);
            } else if (state.signinStatus == SigninStatus.success) {
              Navigator.pushReplacementNamed(
                  context,
                  HomePage
                      .routeName); // Navigate to HomePage when sign in is successful
            }
          },
          builder: (context, state) {
            return Scaffold(
                body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [Color(0xff955cd1), Color(0xff3fa2fa)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.3, 0.85],
                ),
              ),
              child: Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: ListView(
                    shrinkWrap: true,
                    reverse: true,
                    children: [
                      Image.asset(
                        'assets/images/sunny.png',
                        width: 250,
                        height: 250,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email)),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!isEmail(value.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _email = value;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock)),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password required';
                          }
                          if (value.trim().length < 6) {
                            return 'Password must be at least 6 characterrs long';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _password = value;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: state.signinStatus == SigninStatus.submitting
                            ? null
                            : _submit,
                        child: Text(
                          state.signinStatus == SigninStatus.submitting
                              ? 'Loading ..'
                              : 'Sign In',
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<SigninCubit>().signInWithGoogle();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/images/google.png',
                                height: 140.0),
                            Image.asset('assets/images/facebook.png',
                                height: 140.0),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: state.signinStatus == SigninStatus.submitting
                            ? null
                            : () {
                                Navigator.pushNamed(
                                    context, SignupPage.routeName);
                              },
                        child: Text('Not a member yet ? Sign Up!'),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(
                                fontSize: 20.0,
                                decoration: TextDecoration.underline,
                                color: Colors.yellow)),
                      )
                    ].reversed.toList(),
                  ),
                ),
              )),
            ));
          },
        ),
      ),
    );
  }
}
