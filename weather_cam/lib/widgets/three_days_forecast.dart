import 'package:flutter/material.dart';

class ThreeDaysForecast extends StatelessWidget {
  final String date;
  final IconData icon;
  final String temperature;

  const ThreeDaysForecast({
    Key? key,
    required this.date,
    required this.icon,
    required this.temperature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
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
      child: Column(
        children: [
          Text(
            date,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'MavenPro'),
          ),
          Icon(
            icon,
            size: 40,
            color: Colors.yellow[700],
          ),
          Text(
            temperature,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'MavenPro'),
          ),
        ],
      ),
    );
  }
}
