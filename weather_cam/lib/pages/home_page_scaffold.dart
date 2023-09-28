import 'package:flutter/material.dart';
import 'package:my_capstone_weather/widgets/app_bar.dart';
import 'package:my_capstone_weather/widgets/home_page_body.dart';

class HomePageScaffold extends StatelessWidget {
  const HomePageScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff955cd1), Color(0xff3fa2fa)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.3, 0.85],
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(),
        body: HomePageBody(),
      ),
    );
  }
}
