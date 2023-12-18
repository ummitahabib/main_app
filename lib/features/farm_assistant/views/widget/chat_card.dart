import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_assistant/data/model/chat_model.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/audio_player_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    this.width = SpacingConstants.size320,
    required this.chart,
    required this.playingAudioPath,
    required this.setPlayingAudio,
    super.key,
  });
  final double? width;
  final ChatModel chart;
  final String playingAudioPath;
  final Function(String value) setPlayingAudio;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: SpacingConstants.size20,
        right: SpacingConstants.size20,
      ),
      child: Visibility(
        visible: !chart.isAudio!,
        replacement: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: SpacingConstants.size10),
                      width: width,
                      decoration: const BoxDecoration(
                        color: AppColors.SmatCrowPrimary500,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SpacingConstants.size10),
                          topRight: Radius.circular(SpacingConstants.size10),
                          bottomLeft: Radius.circular(SpacingConstants.size10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AudioPlayerWidget(
                                  playingAudio:
                                      playingAudioPath == chart.question,
                                  setPlayingAudio: setPlayingAudio,
                                  audioFilePath: chart.question,
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: chart.translateText != "",
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: SpacingConstants.size10,
                                    right: SpacingConstants.size10,
                                    top: SpacingConstants.size5,
                                  ),
                                  child: SizedBox(
                                    width: width! - SpacingConstants.size20,
                                    child: ChatTextWidget(
                                      chartText: chart.translateText!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: SpacingConstants.size10),
                        ],
                      ),
                    ),
                  ],
                ),
                SpacingConstants.getSmatCrowSize(
                  height: SpacingConstants.size10,
                ),
                SentWidget(chatSent: chart.startTime ?? ""),
              ],
            ),
            Visibility(
              visible: !chart.isNewChat!,
              replacement: const ChatLoader(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airSmat,
                    style: Styles.smatCrowSmallBold(
                      color: AppColors.SmatCrowNeuBlue900,
                    ),
                  ),
                  SpacingConstants.getSmatCrowSize(
                    height: SpacingConstants.size10,
                  ),
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: SpacingConstants.size10),
                        width: width,
                        decoration: const BoxDecoration(
                          color: AppColors.SmatCrowNeuBlue100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SpacingConstants.size10),
                            topRight: Radius.circular(SpacingConstants.size10),
                            bottomRight:
                                Radius.circular(SpacingConstants.size10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AudioPlayerWidget(
                                    playingAudio:
                                        playingAudioPath == chart.answer,
                                    setPlayingAudio: setPlayingAudio,
                                    isLightAudioTheme: true,
                                    audioFilePath: chart.answer,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: chart.transcribeText != "",
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: SpacingConstants.size10,
                                      right: SpacingConstants.size10,
                                      top: SpacingConstants.size5,
                                    ),
                                    child: SizedBox(
                                      width: width! - SpacingConstants.size20,
                                      child: ChatTextWidget(
                                        chartText: chart.transcribeText!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: SpacingConstants.size10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SpacingConstants.getSmatCrowSize(height: 10),
                  SentWidget(
                    chatSent: chart.chatTime ?? "",
                    orderStart: true,
                  ),
                  SpacingConstants.getSmatCrowSize(height: 20),
                ],
              ),
            )
          ],
        ),
        child: Column(
          children: [
            Visibility(
              visible: chart.question != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(SpacingConstants.font10),
                            width: width,
                            decoration: const BoxDecoration(
                              color: AppColors.SmatCrowPrimary500,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: ChatTextWidget(
                              chartText: chart.question ?? "",
                            ),
                          )
                        ],
                      ),
                      SpacingConstants.getSmatCrowSize(
                        height: SpacingConstants.size10,
                      ),
                      SentWidget(chatSent: chart.startTime ?? ""),
                      SpacingConstants.getSmatCrowSize(
                        height: SpacingConstants.size10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !chart.isNewChat!,
              replacement: const ChatLoader(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airSmat,
                    style: Styles.smatCrowSmallBold(
                      color: AppColors.SmatCrowNeuBlue900,
                    ),
                  ),
                  SpacingConstants.getSmatCrowSize(
                    height: SpacingConstants.size10,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(SpacingConstants.font10),
                        width: width,
                        decoration: const BoxDecoration(
                          color: AppColors.SmatCrowNeuBlue100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SpacingConstants.size10),
                            topRight: Radius.circular(SpacingConstants.size10),
                            bottomRight:
                                Radius.circular(SpacingConstants.size10),
                          ),
                        ),
                        child: ChatTextWidget(
                          chartText: chart.answer ?? "",
                        ),
                      )
                    ],
                  ),
                  SpacingConstants.getSmatCrowSize(
                    height: SpacingConstants.size10,
                  ),
                  SentWidget(
                    chatSent: chart.chatTime ?? "",
                    orderStart: true,
                  ),
                  SpacingConstants.getSmatCrowSize(
                    height: SpacingConstants.size20,
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

class ChatTextWidget extends StatelessWidget {
  const ChatTextWidget({
    super.key,
    required this.chartText,
  });

  final String chartText;

  @override
  Widget build(BuildContext context) {
    return Text(
      chartText,
      style: Styles.smatCrowCaptionRegular(
        color: AppColors.SmatCrowNeuBlue900,
      ).copyWith(height: 1.9),
    );
  }
}

class SentWidget extends StatelessWidget {
  const SentWidget({super.key, this.chatSent = "", this.orderStart = false});

  final String? chatSent;
  final bool orderStart;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          orderStart ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Text(
          "$sent: $chatSent",
          style: Styles.smatCrowSmallTextRegular(
            color: AppColors.SmatCrowNeuBlue500,
          ),
        ),
      ],
    );
  }
}

class ChatLoader extends StatelessWidget {
  const ChatLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.SmatCrowPrimary400,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: SpacingConstants.size10,
            vertical: SpacingConstants.size5,
          ),
          width: SpacingConstants.size200,
          height: SpacingConstants.size50,
          child: Center(
            child: Text(
              recording,
              style: Styles.smatCrowSmallTextRegular(
                color: AppColors.SmatCrowNeuBlue900,
              ).copyWith(
                fontSize: SpacingConstants.size16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
