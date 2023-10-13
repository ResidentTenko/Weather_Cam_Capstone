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
        appBar: AppBar(title: const Text('Profile')),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff955cd1), Color(0xff3fa2fa)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.3, 0.85],
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
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.white), // Name icon
                          SizedBox(width: 20.0),
                          Text(
                            'Name: ${state.user.name}',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.white), // Email icon
                          SizedBox(width: 10.0),
                          Text(
                            'Email: ${state.user.email}',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(Icons.perm_identity,
                              color: Colors.white), // ID icon
                          SizedBox(width: 10.0),
                          Text(
                            'ID: ${state.user.id}',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
