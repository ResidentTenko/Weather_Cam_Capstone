import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
                _buildYoutubeButton(
                    context, 'New York, Usa', 'GSmCh4DrbWY', 'newyork.png'),
                _buildYoutubeButton(
                    context, 'Berlin, Germany', 'bImfEZie92U', 'berlin.png'),
                _buildYoutubeButton(
                    context, 'Paris, France', 'SAxZ03mTMb0', 'paris.png'),
                _buildYoutubeButton(
                    context, 'Rome, Italy', 'RDqrx6S2z20', 'milano.png'),
                _buildYoutubeButton(
                    context, 'Vegas, Usa', 'y1qDzW_yWko', 'vegas.png'),
                _buildYoutubeButton(
                    context, 'Worldwide', '3dEfax7mkbE', 'world.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // City, Video id and the .png
  Widget _buildYoutubeButton(
      BuildContext context, String title, String videoId, String imageName) {
    return GestureDetector(
      onTap: () => _openYoutubePlayer(context, videoId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/$imageName',
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 220.0,
              child: AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText(
                    title,
                    textStyle: const TextStyle(
                      fontFamily: 'Aptos',
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    duration: const Duration(milliseconds: 3000),
                  ),
                ],
                repeatForever: true,
                onTap: () => _openYoutubePlayer(context, videoId),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to Youtube Player Screen
  void _openYoutubePlayer(BuildContext context, String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubePlayerScreen(videoId: videoId),
      ),
    );
  }
}

// Youtube Live Cam Screen

class YoutubePlayerScreen extends StatelessWidget {
  final String videoId;

  const YoutubePlayerScreen({Key? key, required this.videoId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff955cd1), Color(0xff3fa2fa)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.3, 0.85],
          ),
        ),
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: controller,
          ),
          builder: (context, player) => Center(
            child: player,
          ),
        ),
      ),
    );
  }
}
