import 'package:flutter/material.dart';
import 'package:flutter_application/pages/live_cam_stream.dart';
import 'package:flutter_application/widgets/select_live_cam_button.dart';

class LiveCamSelect extends StatelessWidget {
  const LiveCamSelect({Key? key}) : super(key: key);

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xff955cd1), size: 40),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                SelectLiveCamButton(
                  title: 'Times Square',
                  onPressed: () {
                    _openWebView(
                      context,
                      'https://www.earthcam.com/usa/newyork/timessquare/?cam=tsrobo1',
                    );
                  },
                ),
                const SizedBox(height: 40),
                SelectLiveCamButton(
                  title: 'World Trade Center',
                  onPressed: () {
                    _openWebView(
                      context,
                      'https://www.earthcam.com/usa/newyork/worldtradecenter/?cam=skyline_g',
                    );
                  },
                ),
                const SizedBox(height: 40),
                SelectLiveCamButton(
                  title: 'Rockefeller Observatory',
                  onPressed: () {
                    _openWebView(
                      context,
                      "https://www.earthcam.com/usa/newyork/rockefellercenter/?cam=rockefellerobservatory",
                    );
                  },
                ),
                const SizedBox(height: 40),
                SelectLiveCamButton(
                  title: 'Statue of Liberty',
                  onPressed: () {
                    _openWebView(
                      context,
                      'https://www.earthcam.com/usa/newyork/statueofliberty/?cam=liberty_str',
                    );
                  },
                ),
                const SizedBox(height: 40),
                SelectLiveCamButton(
                  title: '. . . ',
                  onPressed: () {
                    _openWebView(
                      context,
                      'https://www.earthcam.com',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveCamStream(url: url),
      ),
    );
  }
}
