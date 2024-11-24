// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/model/Musics.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({required Key key, required this.mMusic}) : super(key: key);
  final Musics mMusic;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  IconData btnIcon = Icons.play_arrow;
  final bgColor = const Color(0xFF03174C);
  final iconHoverColor = const Color(0xFF065BC3);

  Duration duration = const Duration();
  Duration position = const Duration();

  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentSong = "";

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      await audioPlayer.pause();
      await audioPlayer.play(UrlSource(url));
      setState(() {
        currentSong = url;
      });
    } else if (!isPlaying) {
      await audioPlayer.play(UrlSource(url));
      setState(() {
        isPlaying = true;
        btnIcon = Icons.pause;
      });
    }

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        btnIcon = isPlaying ? Icons.pause : Icons.play_arrow;
      });
    });

    audioPlayer.onPositionChanged.listen((pos) {
      setState(() {
        position = pos;
      });
    });

    audioPlayer.onDurationChanged.listen((dur) {
      setState(() {
        duration = dur;
      });
    });
  }

  void seekTo(double seconds) {
    audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the slider's maximum value
    double maxSliderValue =
        duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0;

    // Ensure position is always within bounds for the slider
    double currentSliderValue = position.inSeconds.toDouble();
    if (currentSliderValue > maxSliderValue) {
      currentSliderValue = maxSliderValue;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF03174C),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 500.0,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.mMusic.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [bgColor.withOpacity(0.4), bgColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 52.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'PLAYLIST',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                                const Text(
                                  'Best Vibes of the Week',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.playlist_add,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const Spacer(),
                        Text(
                          widget.mMusic.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          widget.mMusic.singer,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 18.0),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 42.0),
            Slider.adaptive(
              value: currentSliderValue,
              min: 0.0,
              max: maxSliderValue,
              onChanged: (value) {
                seekTo(value);
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.fast_rewind,
                    color: Colors.white54, size: 42.0),
                const SizedBox(width: 32.0),
                Container(
                  decoration: BoxDecoration(
                      color: iconHoverColor,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          audioPlayer.pause();
                          setState(() {
                            btnIcon = Icons.play_arrow;
                            isPlaying = false;
                          });
                        } else {
                          playMusic(widget.mMusic.url);
                        }
                      },
                      iconSize: 42.0,
                      icon: Icon(btnIcon),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 32.0),
                const Icon(Icons.fast_forward,
                    color: Colors.white54, size: 42.0),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.bookmark_border, color: iconHoverColor),
                Icon(Icons.shuffle, color: iconHoverColor),
                Icon(Icons.repeat, color: iconHoverColor),
              ],
            ),
            const SizedBox(height: 58.0),
          ],
        ),
      ),
    );
  }
}
