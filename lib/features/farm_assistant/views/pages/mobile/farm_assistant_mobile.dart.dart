import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_assistant/data/controller/chat_controller.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/chat_card.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/chat_message_widget.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/farm_assistant_app_bar.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/farm_assistant_drawer.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmAssistantMobileView extends HookConsumerWidget {
  const FarmAssistantMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmRepositoryData = ref.watch(farmAssistanceProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      drawer: const FarmAssistantDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            FarmAssistantAppBar(
              resetAudio: () {
                farmRepositoryData.resetPlayingAudio();
              },
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: farmRepositoryData
                          .getChats(
                            selectedSession:
                                farmRepositoryData.selectedSession?.sessionId,
                          )
                          .length,
                      itemBuilder: (context, index) {
                        return ChatCard(
                          playingAudioPath: farmRepositoryData.playingAudio,
                          setPlayingAudio: farmRepositoryData.setPlayingAudio,
                          width: width > 280 ? SpacingConstants.size320 : 240,
                          chart: farmRepositoryData.getChats(
                            selectedSession:
                                farmRepositoryData.selectedSession?.sessionId,
                          )[index],
                        );
                      },
                    ),
                  ),
                  ChatMessageWidget(
                    playingAudioPath: farmRepositoryData.playingAudio,
                    setPlayingAudio: farmRepositoryData.setPlayingAudio,
                    controller: farmRepositoryData.chatController,
                    onSendMessage: () {
                      farmRepositoryData.chatWithBot();
                    },
                    onAudioMessageSent: (value) {
                      farmRepositoryData.audioChatWithBot(filePath: value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
