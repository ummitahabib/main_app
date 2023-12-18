import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_assistant/data/controller/chat_controller.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/chat_card.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/chat_message_widget.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/farm_assistant_drawer.dart';
import 'package:smat_crow/utils2/constants.dart';
import '../../../../../utils2/colors.dart';
import '../../../../../utils2/spacing_constants.dart';
import '../../../../../utils2/styles.dart';

class FarmAssistantWebView extends HookConsumerWidget {
  const FarmAssistantWebView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final farmRepositoryData = ref.watch(farmAssistanceProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const FarmAssistantWebDrawer(),
          const VerticalDivider(
            thickness: SpacingConstants.size1point5,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: SpacingConstants.size20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        farmAssistant,
                        style: Styles.smatCrowBodyBold(
                          color: AppColors.SmatCrowPrimary900,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          farmRepositoryData.resetPlayingAudio();
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: SpacingConstants.size2,
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      SpacingConstants.getSmatCrowSize(
                        height: SpacingConstants.size20,
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          itemCount: farmRepositoryData
                              .getChats(
                                selectedSession: farmRepositoryData
                                    .selectedSession?.sessionId,
                              )
                              .length,
                          itemBuilder: (context, index) {
                            return ChatCard(
                              playingAudioPath: farmRepositoryData.playingAudio,
                              setPlayingAudio:
                                  farmRepositoryData.setPlayingAudio,
                              chart: farmRepositoryData.getChats(
                                selectedSession: farmRepositoryData
                                    .selectedSession?.sessionId,
                              )[index],
                              width: width > SpacingConstants.size900
                                  ? SpacingConstants.size380
                                  : SpacingConstants.size263,
                            );
                          },
                        ),
                      ),
                      SpacingConstants.getSmatCrowSize(
                        height: SpacingConstants.size20,
                      ),
                      ChatMessageWidget(
                        playingAudioPath: farmRepositoryData.playingAudio,
                        setPlayingAudio: farmRepositoryData.setPlayingAudio,
                        onAudioMessageSent: (value) {
                          farmRepositoryData.audioChatWithBot(
                            filePath: value,
                          );
                        },
                        controller: farmRepositoryData.chatController,
                        onSendMessage: () {
                          farmRepositoryData.chatWithBot();
                        },
                      ),
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
}
