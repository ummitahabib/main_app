import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../../../../utils2/colors.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String? audioFilePath;

  final double? width;
  final double? height;
  final bool isLightAudioTheme;
  final bool playingAudio;
  final Function(String value) setPlayingAudio;
  const AudioPlayerWidget({
    super.key,
    this.audioFilePath,
    this.width,
    this.height,
    required this.setPlayingAudio,
    this.playingAudio = false,
    this.isLightAudioTheme = false,
  });

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();
  Future<void> playAudio(String filePath) async {
    widget.setPlayingAudio(widget.audioFilePath!);
    await audioPlayer.play(
      DeviceFileSource(widget.audioFilePath!),
    );
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
      if (!widget.playingAudio) {
        pauseAudio();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? SpacingConstants.size30,
      width: widget.width ?? SpacingConstants.sizeDouble300,
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: SpacingConstants.size30,
            ),
            onPressed: () {
              if (isPlaying) {
                pauseAudio();
              } else {
                if (widget.audioFilePath != null) {
                  playAudio(widget.audioFilePath!);
                }
              }
            },
          ),
          Expanded(
            child: Slider(
              activeColor: widget.isLightAudioTheme
                  ? AppColors.SmatCrowPrimary500
                  : AppColors.SmatCrowNeuBlue100,
              inactiveColor: widget.isLightAudioTheme
                  ? AppColors.SmatCrowPrimary200
                  : AppColors.SmatCrowNeuBlue300,
              max: duration.inSeconds.toDouble() == 0
                  ? SpacingConstants.size100
                  : duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {},
            ),
          ),
        ],
      ),
    );
  }
}

String formatString(Duration duration) {
  return "${duration.inMinutes} : ${duration.inSeconds}";
}
