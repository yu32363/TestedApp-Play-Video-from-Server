import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class TestVideoList extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  TestVideoList({this.videoPlayerController, this.looping});

  @override
  _TestVideoListState createState() => _TestVideoListState();
}

class _TestVideoListState extends State<TestVideoList> {
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        looping: widget.looping,
        autoPlay: false,
        autoInitialize: true,
        aspectRatio: 3 / 2,
        errorBuilder: (context, errorMsg) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Chewie(controller: chewieController),
    );
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
  }
}
