import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'test_play_video.dart';
import 'test_video_list.dart';

void main() => runApp(MaterialApp(
      home: PlayVideoFromServer(),
      theme: ThemeData(primaryColor: Colors.indigo),
    ));

class PlayVideoFromServer extends StatefulWidget {
  @override
  _PlayVideoFromServerState createState() => _PlayVideoFromServerState();
}

class _PlayVideoFromServerState extends State<PlayVideoFromServer> {
  File _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  VideoPlayerController _videoPlayerController;

  final textController = TextEditingController();

  Future choiceVideo() async {
    var pickedImage = await picker.getVideo(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxDuration: Duration(seconds: 15),
    );

    _image = File(pickedImage.path);

    _videoPlayerController = VideoPlayerController.file(_image)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
      });
  }

  Future uploadVideo() async {
    final uri =
        Uri.parse("http://192.168.5.228/image_upload_php_mysql/upload.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameController.text;
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Video Uploaded');
    } else {
      print('Video Not Uploaded');
    }
  }

  List videoList;
  bool loading = true;

  Future allImage() async {
    var response = await http
        .get(Uri.http('192.168.5.228', '/image_upload_php_mysql/viewall.php'));
    if (response.statusCode == 200) {
      setState(() {
        videoList = jsonDecode(response.body);
        loading = false;
      });
    }
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    allImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Video from Server'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              margin: EdgeInsets.all(10),
              child: FutureBuilder(
                future: allImage(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data;
                            return Container(
                              color: Colors.grey[200],
                              width: 150,
                              height: 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ถังลมที่: ${list[index]['name']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.play_circle_fill,
                                        color: Theme.of(context).primaryColor,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TestPlayVideo(
                                              url:
                                                  'http://192.168.5.228/image_upload_php_mysql/uploads/${list[index]['image']}',
                                            ),
                                          ),
                                        );
                                      }),
                                  IconButton(
                                    icon: Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      list.remove(list[index]);
                                    },
                                  ),
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.grey[200],
                  height: 60,
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_image != null)
                        _videoPlayerController.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: 1,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VideoPlayer(_videoPlayerController),
                                    IconButton(
                                        icon: Icon(
                                          _videoPlayerController.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          _videoPlayerController.value.isPlaying
                                              ? _videoPlayerController.pause()
                                              : _videoPlayerController.play();
                                          setState(() {});
                                        })
                                  ],
                                ),
                              )
                            : Container()
                      else
                        Text(
                          '',
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      choiceVideo();
                    },
                    child: Icon(
                      Icons.video_call,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      setState(() {
                        uploadVideo();
                      });
                    },
                    child: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
