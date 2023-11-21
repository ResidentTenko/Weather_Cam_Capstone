// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/signin/signin_cubit.dart';
import 'package:flutter_application/pages/signup_page.dart';
import 'package:flutter_application/utils/error_dialog.dart';
import 'package:validators/validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff3fa2fa),
                    Color(0xFF7F8DA2),
                    Color(0xFFFD5E53),
                  ],
                  stops: [
                    0.33,
                    0.66,
                    0.99,
                  ], // Adjust stops based on your preference
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                          ),
                        ),
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
                      InkWell(
                        onTap: state.signinStatus == SigninStatus.submitting
                            ? null
                            : _submit,
                        child: state.signinStatus == SigninStatus.submitting
                            ? Center(
                                child: LoadingAnimationWidget.twistingDots(
                                  leftDotColor: Color(0xff3fa2fa),
                                  rightDotColor: const Color(0xFFFD5E53),
                                  size: 50,
                                ),
                              ) // Show loading indicator when submitting
                            : SizedBox(
                                width: 100, // Set your desired width
                                height: 120, // Set your desired height
                                child: Image.asset('assets/images/login.png',
                                    fit: BoxFit.contain),
                              ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.read<SigninCubit>().signInWithGoogle();
                              },
                              child: Image.asset('assets/images/google.png',
                                  height: 120.0),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context
                                    .read<SigninCubit>()
                                    .signInWithFacebook();
                              },
                              child: Image.asset('assets/images/facebook.png',
                                  height: 120.0),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: state.signinStatus == SigninStatus.submitting
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  SignupPage.routeName,
                                );
                              },
                        child: Text(
                          'Not a member yet ? Sign Up!',
                        ),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(
                          fontSize: 22.0,
                          decoration: TextDecoration.underline,
                        )),
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
