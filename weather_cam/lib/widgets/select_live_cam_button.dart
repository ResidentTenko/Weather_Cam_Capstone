// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SelectLiveCamButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const SelectLiveCamButton({
    Key? key,
    required this.onPressed,
    required this.title,
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
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
