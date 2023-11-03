// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThreeDaysForecast extends StatelessWidget {
  final int day;
  final String imageUrl;
  final String forcastMinTemp;
  final String forcastMaxTemp;

  const ThreeDaysForecast({
    Key? key,
    required this.day,
    required this.imageUrl,
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
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff955cd1),
          borderRadius: BorderRadius.circular(15.0),
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
                    day * 1000,
                    isUtc: true,
                  ),
                )}:',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'MavenPro',
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.network(
                imageUrl, // Use the imageUrl to load the image from a network URL
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            Text(
              '$forcastMinTemp / $forcastMaxTemp',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'MavenPro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
