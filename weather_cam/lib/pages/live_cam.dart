import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LiveCamPage extends StatelessWidget {
  const LiveCamPage({Key? key}) : super(key: key);

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
                _buildButton(
                    context,
                    "https://www.earthcam.com/usa/newyork/timessquare/?cam=tsrobo1",
                    'Times Square'),
                const SizedBox(height: 40),
                _buildButton(
                    context,
                    "https://www.earthcam.com/usa/newyork/worldtradecenter/?cam=skyline_g",
                    'World Trade Center'),
                const SizedBox(height: 40),
                _buildButton(
                    context,
                    "https://www.earthcam.com/usa/newyork/rockefellercenter/?cam=rockefellerobservatory",
                    'Rockefeller Observatory'),
                const SizedBox(height: 40),
                _buildButton(
                    context,
                    "https://www.earthcam.com/usa/newyork/statueofliberty/?cam=liberty_str",
                    'Statue of Liberty'),
                const SizedBox(height: 40),
                _buildButton(context, "https://www.earthcam.com", '. . . '),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String url, String title) {
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
          _openWebView(context, url);
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

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xff955cd1),
          size: 30,
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(url),
        ),
      ),
    );
  }
}
