import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/auth/auth_bloc.dart';
import 'package:flutter_application/blocs/temp_settings/temp_settings_cubit.dart';
import 'package:flutter_application/blocs/weather/weather_bloc.dart';
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
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 35),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/home.png',
                        width: 65,
                        height: 65,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Home",
                        style: TextStyle(
                          color: Color(
                            0xff955cd1,
                          ),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/livecam.png',
                        width: 65,
                        height: 65,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "LiveCam",
                        style: TextStyle(
                          color: Color(
                            0xff955cd1,
                          ),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/temp.png',
                        width: 65,
                        height: 65,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        context.read<TempSettingsCubit>().state.tempUnit ==
                                TempUnit.celsius
                            ? "°F"
                            : "°C",
                        style: const TextStyle(
                          color: Color(
                            0xff955cd1,
                          ),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/speed.png',
                        width: 65,
                        height: 65,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        context
                                    .read<TempSettingsCubit>()
                                    .state
                                    .measurementUnit ==
                                MeasurementUnit.kilometers
                            ? "Mi"
                            : "Km",
                        style: const TextStyle(
                          color: Color(
                            0xff955cd1,
                          ),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 5,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logout.png',
                        width: 65,
                        height: 65,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Logout",
                        style: TextStyle(
                          color: Color(0xff955cd1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
                  context
                      .read<WeatherBloc>()
                      .add(FetchWeatherFromLocationEvent());
                } else if (value == 2) {
                  _openLiveCamPage(context);
                } else if (value == 3) {
                  context.read<TempSettingsCubit>().toggleTempUnit();
                } else if (value == 4) {
                  context.read<TempSettingsCubit>().toggleMeasurementUnit();
                } else if (value == 5) {
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
