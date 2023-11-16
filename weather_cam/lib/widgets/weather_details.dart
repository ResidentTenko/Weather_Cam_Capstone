// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WeatherDetails extends StatelessWidget {
  final IconData detailIcon;
  final String detailTitle;
  final String detailValue;

  const WeatherDetails({
    Key? key,
    required this.detailIcon,
    required this.detailTitle,
    required this.detailValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff955cd1),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color(0xff3fa2fa),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            detailIcon,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            detailTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'MavenPro',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            detailValue,
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
