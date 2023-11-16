// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';

class ThreeDaysForecast extends StatelessWidget {
  final int forecastDay;
  final String forecastCondition;
  final String forecastIcon;
  final String forcastMinTemp;
  final String forcastMaxTemp;

  const ThreeDaysForecast({
    Key? key,
    required this.forecastDay,
    required this.forecastCondition,
    required this.forecastIcon,
    required this.forcastMinTemp,
    required this.forcastMaxTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff955cd1),
          borderRadius: BorderRadius.circular(10.0),
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
            Expanded(
              child: Text(
                '${DateFormat('E').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    forecastDay * 1000,
                    isUtc: true,
                  ),
                )}:',
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
                'https:$forecastIcon', // Use the imageUrl to load the image from a network URL
                fit: BoxFit.cover,
                alignment: Alignment
                    .center, // Align the image to the center of the container
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: TextScroll(
                forecastCondition,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'MavenPro',
                ),
                pauseBetween: const Duration(milliseconds: 2000),
                mode: TextScrollMode.endless,
                numberOfReps: 100,
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                selectable: true,
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              '$forcastMinTemp / $forcastMaxTemp',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'MavenPro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
