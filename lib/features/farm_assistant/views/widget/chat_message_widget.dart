import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/audio_recorder.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/custom_send_button.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import '../../../presentation/widgets/custom_text_field.dart';

class ChatMessageWidget extends StatefulWidget {
  const ChatMessageWidget({
    required this.controller,
    required this.onSendMessage,
    required this.onAudioMessageSent,
    required this.setPlayingAudio,
    required this.playingAudioPath,
    this.audioPlayerWidth,
    super.key,
  });
  final Function() onSendMessage;
  final Function(String value) onAudioMessageSent;
  final TextEditingController controller;
  final double? audioPlayerWidth;

  final String playingAudioPath;
  final Function(String value) setPlayingAudio;

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  bool showAudioInterface = false;
  void toggleShowAudioInterphase(bool value) {
    showAudioInterface = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !showAudioInterface,
      replacement: AudioRecorder(
        setPlayingAudio: widget.setPlayingAudio,
        playingAudioPath: widget.playingAudioPath,
        onStop: (String path) {
          // debugPrint(path);
          toggleShowAudioInterphase(false);
          widget.onAudioMessageSent(path);
        },
        onCancel: () {
          toggleShowAudioInterphase(false);
        },
      ),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                toggleShowAudioInterphase(true);
              },
              icon: const Icon(
                Icons.mic_none,
                size: SpacingConstants.size30,
              ),
            ),
            SpacingConstants.getSmatCrowSize(width: SpacingConstants.size10),
            Expanded(
              child: CustomTextField(
                onPressEnter: widget.onSendMessage,
                text: "",
                textEditingController: widget.controller,
                hintText: sendMessage,
                type: TextFieldType.Default,
              ),
            ),
            SpacingConstants.getSmatCrowSize(width: SpacingConstants.size20),
            Padding(
              padding: const EdgeInsets.only(top: SpacingConstants.size10),
              child: CustomSendButton(
                onTapSend: widget.onSendMessage,
              ),
            ),
            SpacingConstants.getSmatCrowSize(width: SpacingConstants.size20),
          ],
        ),
      ),
    );
  }
}
