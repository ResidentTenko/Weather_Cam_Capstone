// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyForecast extends StatelessWidget {
  final int hourlyTime;
  final String hourlyIcon;
  final String hourlyTemp;

  const HourlyForecast({
    Key? key,
    required this.hourlyTime,
    required this.hourlyIcon,
    required this.hourlyTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(149, 92, 209, 0.0),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color(0xff3fa2fa),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Text(
              DateFormat('jm').format(
                DateTime.fromMillisecondsSinceEpoch(
                  hourlyTime * 1000,
                  isUtc: true,
                ).toLocal()
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'MavenPro',
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: Image.network(
              'https:$hourlyIcon',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            hourlyTemp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'MavenPro',
            ),
          ),
        ],
      ),
    );
  }
}
