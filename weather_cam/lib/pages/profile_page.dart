// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/auth/auth_bloc.dart';
import 'package:flutter_application/blocs/profile/profile_cubit.dart';
import 'package:flutter_application/utils/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _getProfile() {
    final String uid = context.read<AuthBloc>().state.user!.uid;
    print('uid: $uid');
    context.read<ProfileCubit>().getProfile(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignoutRequestedEvent());
                },
                icon: Icon(
                  Icons.logout_rounded,
                ))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff955cd1), Color(0xff3fa2fa)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.4, 0.85],
            ),
          ),
          child: Center(
            child: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state.profileStatus == ProfileStatus.error) {
                  errorDialog(context, state.error);
                }
              },
              builder: (context, state) {
                if (state.profileStatus == ProfileStatus.initial) {
                  return Container();
                } else if (state.profileStatus == ProfileStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.profileStatus == ProfileStatus.error) {
                  return Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Error image'),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text('Opps!\n Try again')
                        ]),
                  );
                }
                return Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/sunny.png',
                          width: 250,
                          height: 250,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff955cd1),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xff3fa2fa),
                                  blurRadius: 4.0,
                                  offset: Offset(-3.0, 3.0),
                                ),
                                BoxShadow(
                                  color: Color(0xff3fa2fa),
                                  blurRadius: 4.0,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.person,
                                    color: Colors.white, size: 30.0),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: Text(
                                    'Name: ${state.user.name}',
                                    style: TextStyle(
                                        fontSize: 24.0, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff955cd1),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xff3fa2fa),
                                  blurRadius: 4.0,
                                  offset: Offset(-3.0, 3.0),
                                ),
                                BoxShadow(
                                  color: Color(0xff3fa2fa),
                                  blurRadius: 4.0,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.email,
                                    color: Colors.white, size: 30.0),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: Text(
                                    'Email: ${state.user.email}',
                                    style: TextStyle(
                                        fontSize: 24.0, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff955cd1),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xff3fa2fa),
                                  blurRadius: 4.0,
                                  offset: Offset(-3.0, 3.0),
                                ),
                                BoxShadow(
                                  color: Color(0xff3fa2fa),
                                  blurRadius: 4.0,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.location_city,
                                    color: Colors.white, size: 30.0),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: Text(
                                    'Location: Mountain View',
                                    style: TextStyle(
                                        fontSize: 24.0, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff955cd1),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xff3fa2fa),
                                  blurRadius: 4.0,
                                  offset: Offset(-3.0, 3.0),
                                ),
                                BoxShadow(
                                  color: Color(0xff3fa2fa),
                                  blurRadius: 4.0,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.perm_identity,
                                    color: Colors.white, size: 30.0),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: Text(
                                    'ID: ${state.user.id}',
                                    style: TextStyle(
                                        fontSize: 24.0, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
