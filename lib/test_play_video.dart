import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class TestPlayVideo extends StatefulWidget {
  final String url;
  TestPlayVideo({this.url});

  @override
  _TestPlayVideoState createState() => _TestPlayVideoState();
}

class _TestPlayVideoState extends State<TestPlayVideo> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  Future initializeVideo() async {
    _videoPlayerController = VideoPlayerController.network(widget.url);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เล่นวิดิโอ'),
      ),
      body: Center(
        child: Container(
          height: 250,
          child: _chewieController != null &&
                  _chewieController.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController,
                )
              : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
