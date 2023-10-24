import 'package:flutter/material.dart';
import 'package:flutter_application/pages/live_cam_select.dart';
import 'package:flutter_application/pages/profile_page.dart';

class LiveViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LiveViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 35),
            //to build the list of items Profile and LiveCam
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xff955cd1)),
                    SizedBox(width: 10),
                    Text("Profile"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.photo_camera_front, color: Color(0xff955cd1)),
                    SizedBox(width: 10),
                    Text("LiveCam"),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                _openProfilePage(context);
              } else if (value == 2) {
                _openLiveCamPage(context);
              }
            },
          ),
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

  void _openProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  //prefersize of the widget default size of the app bar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
