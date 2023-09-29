import 'package:flutter/material.dart';
import 'package:my_capstone_weather/pages/live_cam_select.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: IconButton(
            icon: const Icon(Icons.photo_camera_front,
                color: Color(0xff955cd1), size: 48),
            onPressed: () {
              _openLiveCamPage(context); // Update to return LiveCam
            },
          ),
        )
      ],
    );
  }

  void _openLiveCamPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LiveCamSelect(), // Return the  LiveCamPage
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
