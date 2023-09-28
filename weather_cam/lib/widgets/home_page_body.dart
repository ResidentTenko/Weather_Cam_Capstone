import 'package:flutter/material.dart';
import 'package:my_capstone_weather/widgets/three_days_forecast.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          const Text(
            "New York, NY",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontFamily: 'MavenPro'),
          ),
          const SizedBox(height: 15),
          Image.asset('images/sunny.png',
              width: 180, height: 180, fit: BoxFit.fill),
          const Text(
            "Sunny",
            style: TextStyle(
                color: Colors.white, fontSize: 35, fontFamily: 'MavenPro'),
          ),
          const SizedBox(height: 2),
          const Text(
            "19°",
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontFamily: 'MavenPro',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Feels like Summer",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'Hubballi'),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Min : 18°",
                style: TextStyle(
                    color: Colors.white, fontSize: 22, fontFamily: 'MavenPro'),
              ),
              SizedBox(width: 15),
              Text(
                "Max : 21°",
                style: TextStyle(
                    color: Colors.white, fontSize: 22, fontFamily: 'MavenPro'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Today                   Sep,28th",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Hubballi'),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ThreeDaysForecast(
                  date: "Fri", icon: Icons.sunny, temperature: "22°"),
              ThreeDaysForecast(
                  date: "Sat", icon: Icons.cloud, temperature: "21°"),
              ThreeDaysForecast(
                  date: "Sun", icon: Icons.cloud, temperature: "20°"),
            ],
          ),
        ],
      ),
    );
  }
}
