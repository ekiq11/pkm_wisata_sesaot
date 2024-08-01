import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../constant.dart';
import '../gmap/current_loc.dart';

class Youtube extends StatefulWidget {
  final String? video, nama, img, alamat;
  final String? desc, lat, lang;

  const Youtube({
    Key? key,
    this.video,
    this.nama,
    this.desc,
    this.lat,
    this.lang,
    this.img,
    this.alamat,
  }) : super(key: key);

  @override
  _YoutubeState createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
          widget.video ?? 'tcodrIK2P_I', // Use provided video ID or default
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nama ?? 'YouTube Player'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              _controller.addListener(() {});
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Tentang ${widget.nama}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.desc ?? ''),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.25,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrentLoc(
                          lat: widget.lat,
                          lang: widget.lang,
                          name: widget.alamat!,
                          img: widget.img!,
                          alamat: widget.alamat),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: kgreen, borderRadius: BorderRadius.circular(15.0)),
                  child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Route ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.directions_outlined,
                          color: Colors.white,
                        )
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
