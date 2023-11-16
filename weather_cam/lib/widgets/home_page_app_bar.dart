import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/auth/auth_bloc.dart';
import 'package:flutter_application/blocs/temp_settings/temp_settings_cubit.dart';
import 'package:flutter_application/pages/live_cam_select.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        Builder(
          builder: (context) {
            return PopupMenuButton<int>(
              icon:
                  const Icon(Icons.more_vert, color: Colors.white, size: 35),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.photo_camera_front,
                          color: Color(0xff955cd1)),
                      SizedBox(width: 10),
                      Text(
                        "LiveCam",
                        style: TextStyle(
                            color: Color(0xff955cd1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      const Icon(Icons.thermostat, color: Color(0xff955cd1)),
                      const SizedBox(width: 10),
                      Text(
                        context.read<TempSettingsCubit>().state.tempUnit ==
                                TempUnit.celsius
                            ? "°F"
                            : "°C",
                        style: const TextStyle(
                            color: Color(0xff955cd1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Color(0xff955cd1)),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(
                            color: Color(0xff955cd1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
                  _openLiveCamPage(context);
                } else if (value == 2) {
                  context.read<TempSettingsCubit>().toggleTempUnit();
                } else if (value == 3) {
                  context.read<AuthBloc>().add(SignoutRequestedEvent());
                }
              },
            );
          },
        ),
      ],
    );
  }

  void _openLiveCamPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LiveCamSelect(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
