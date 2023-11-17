// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/signup/signup_cubit.dart';
import 'package:flutter_application/blocs/signup/signup_state.dart';
import 'package:flutter_application/utils/error_dialog.dart';
import 'package:validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _passwordController = TextEditingController();
  String? _name, _email, _password;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();

    print('name: $_name, email: $_email, password: $_password');

    context
        .read<SignupCubit>()
        .signup(name: _name!, email: _email!, password: _password!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.signupStatus == SignupStatus.error) {
            errorDialog(context, state.error);
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
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Name',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(5),
                            child: SizedBox(
                              width: 50,
                              height: 60,
                              child: Image.asset('assets/images/name.png',
                                  fit: BoxFit.contain),
                            ),
                          )),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _name = value;
                      },
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
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(5),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/images/email.png',
                                  fit: BoxFit.contain),
                            ),
                          )),
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
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Password',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(5),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/images/password.png',
                                  fit: BoxFit.contain),
                            ),
                          )),
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
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Confirm Password',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(5),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/images/password.png',
                                  fit: BoxFit.contain),
                            ),
                          )),
                      validator: (String? value) {
                        if (_passwordController.text != value) {
                          return 'password not match';
                        }

                        return null;
                      },
                      onSaved: (String? value) {
                        _password = value;
                      },
                    ),
                    InkWell(
                      onTap: state.signupStatus == SignupStatus.submitting
                          ? null
                          : _submit,
                      child: state.signupStatus == SignupStatus.submitting
                          ? CircularProgressIndicator() // Show loading indicator when submitting
                          : Image.asset(
                              'assets/images/signup.png',
                              width: 100, // Set your width
                              height: 100, // Set your height
                            ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      onPressed: state.signupStatus == SignupStatus.submitting
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            decoration: TextDecoration.underline,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0)),
                      child: Text(
                        'Already a member? Sign in !',
                      ),
                    ),
                  ].reversed.toList(),
                ),
              ),
            )),
          ));
        },
      ),
    );
  }
}
