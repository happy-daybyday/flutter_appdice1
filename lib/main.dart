import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  return runApp(
    MaterialApp(
      home:Scaffold(
        appBar: AppBar(
          title: Text('扔骰子'),
          centerTitle: true,
        ),

        body: dice(),
        backgroundColor: Colors.green,
      ),
      theme: ThemeData(
          primarySwatch: Colors.green

      ),
    ),
  );
}


class dice extends StatefulWidget {
  @override
  _diceState createState() => _diceState();
}

class _diceState extends State<dice> with WidgetsBindingObserver {
  var diceleft = 1;
  var  diceright = 1;
  static AudioCache audioCache = AudioCache();
  static AudioPlayer audioPlayerWithCache;
  static AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Image.asset('images/dice$diceleft.png'),
              onPressed: _buttonClick,
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Image.asset('images/dice$diceright.png'),
              onPressed: _buttonClick,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _buttonClick();
    WidgetsBinding.instance.addObserver(this);
    _playCacheAudio();
    print('播放背景音乐成功');
  }

  @override
  void dispose() {
    super.dispose();
    _pauseCacheAudio();
    print('停止播放音乐');
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        _resumeCacheAudio();
        break;
      case AppLifecycleState.paused:
        _pauseCacheAudio();
        break;
      case AppLifecycleState.suspending:
        break;
    }
  }

  _playCacheAudio() async {
    audioPlayerWithCache =
        await audioCache.loop('backgroundAudio.mp3', volume: 0.5);
  }

  _pauseCacheAudio() async {
    audioPlayerWithCache.pause();
  }

  _resumeCacheAudio() async {
    await audioPlayerWithCache.resume();
  }

  _playHttpsAudio() async {
    int result = await audioPlayer.play(
        'https://netx-teaching-resource.oss-cn-shenzhen.aliyuncs.com/flutter/video/backgroundAudio.mp3');
    if (result == 1) {
      // success
      audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    }
  }

  _stopHttpsAudio() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      // success
      audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
    }
  }

  void _buttonClick() {
    print('点击按钮');
    AudioCache audioPlayer1 = AudioCache();
    audioPlayer1.play('throwdice.mp3');

    setState(() {
      this.diceleft = Random().nextInt(6) + 1;
      this.diceright = Random().nextInt(6) + 1;
    });
  }
}
