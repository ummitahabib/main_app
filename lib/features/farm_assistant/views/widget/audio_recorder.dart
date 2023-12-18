import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/audio_player_widget.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/custom_send_button.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

Pandora _pandora = Pandora();

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;
  final void Function() onCancel;
  final String playingAudioPath;
  final Function(String value) setPlayingAudio;

  const AudioRecorder({
    Key? key,
    required this.onStop,
    required this.onCancel,
    required this.playingAudioPath,
    required this.setPlayingAudio,
  }) : super(key: key);

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;

  String? filePath;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });
    _start();
    super.initState();
  }

  Future<void> _start() async {
    try {
      const encoder = AudioEncoder.wav;
      if (await _audioRecorder.hasPermission()) {
        if (!kIsWeb) {
          final path = await getPath();
          await _audioRecorder.start(
            encoder: encoder,
            path: path,
          );
          _recordDuration = 0;
          _startTimer();
        } else {
          await _audioRecorder.start(encoder: encoder);
          _recordDuration = 0;
          _startTimer();
        }
      } else {
        snackBarMsg(microphonePermissionNotGranted);
        widget.onCancel();
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'audio recorder',
        'audio recorder',
        'FAILED',
        e.toString(),
      );
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    if (path != null) {
      filePath = path;
    }
    setState(() {});
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: SpacingConstants.size10),
      color: AppColors.FarmManagerColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: _recordState != RecordState.stop,
            replacement: _sendButton(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: SpacingConstants.size230,
                    maxWidth: SpacingConstants.size250,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildRecordStopControl(),
                      _buildText(),
                      _buildPauseResumeControl(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (mounted) {
      _timer?.cancel();
      _recordSub?.cancel();
      _audioRecorder.dispose();
    }

    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    icon = const Icon(
      Icons.stop_outlined,
      color: Colors.white,
      size: SpacingConstants.size30,
    );
    return Material(
      child: InkWell(
        child: Container(
          width: SpacingConstants.size45,
          height: SpacingConstants.size45,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(SpacingConstants.size10),
          ),
          child: icon,
        ),
        onTap: () {
          (_recordState != RecordState.stop) ? _stop() : _start();
        },
      ),
    );
  }

  Widget _sendButton() {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SpacingConstants.size10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            child: InkWell(
              child: Container(
                width: SpacingConstants.size45,
                height: SpacingConstants.size45,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(SpacingConstants.size10),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: SpacingConstants.size30,
                ),
              ),
              onTap: () {
                widget.onCancel();
              },
            ),
          ),
          AudioPlayerWidget(
            playingAudio: widget.playingAudioPath == filePath,
            setPlayingAudio: widget.setPlayingAudio,
            audioFilePath: filePath,
            width: width < SpacingConstants.size290
                ? SpacingConstants.size150
                : SpacingConstants.size230,
          ),
          CustomSendButton(
            onTapSend: () {
              widget.onStop(filePath!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    late Icon icon;

    if (_recordState == RecordState.record) {
      icon = const Icon(
        Icons.pause_outlined,
        color: Colors.white,
        size: SpacingConstants.size30,
      );
      // color = Colors.green;
    } else {
      icon = const Icon(
        Icons.play_arrow_outlined,
        color: Colors.white,
        size: SpacingConstants.size30,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Container(
          width: SpacingConstants.size45,
          height: SpacingConstants.size45,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: icon,
        ),
        onTap: () {
          (_recordState == RecordState.pause) ? _resume() : _pause();
        },
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}

Future<String> getPath() async {
  final dir = await getApplicationDocumentsDirectory();
  if (Platform.isIOS) {
    return p.join(
      dir.path,
      'audio0${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
  } else {
    return p.join(
      dir.path,
      'audio0${DateTime.now().millisecondsSinceEpoch}.wav',
    );
  }
}
