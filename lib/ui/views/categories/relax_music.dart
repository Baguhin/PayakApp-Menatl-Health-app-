// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tangullo/ui/views/model/Musics.dart';
import 'package:tangullo/ui/views/components/custom_list_view.dart';
import 'DetailPage.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late List<Musics> musics;

  @override
  void initState() {
    super.initState();
    musics = getList();
  }

  List<Musics> getList() {
    return [
      Musics(
        title: "Calm Waters",
        singer: "Nature Sounds",
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3",
        image: "https://example.com/images/calm-waters.jpg",
      ),
      Musics(
        title: "Peaceful Mind",
        singer: "Relaxation Guru",
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3",
        image: "https://example.com/images/peaceful-mind.jpg",
      ),
      // Add other calming tracks here...
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9FC5C7), // Light, calming green
      appBar: AppBar(
        backgroundColor: const Color(0xFF627E90), // Muted blue-gray
        title: const Text(
          "Relaxing Music",
          style: TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
              fontSize: 22.0,
              fontWeight: FontWeight.w300), // Soft and light font
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/bg_mountain.svg', // Calming mountain background SVG
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
          ),
          Column(
            children: [
              const SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Find Your Peace",
                  style: TextStyle(
                    color: Color(0xFF627E90),
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: musics.length,
                  itemBuilder: (context, index) => customListView(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                              key: ValueKey(musics[index].title),
                              mMusic: musics[index]),
                        ),
                      );
                    },
                    title: musics[index].title,
                    singer: musics[index].singer,
                    image: musics[index].image,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
