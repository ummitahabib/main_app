import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_assistant/data/controller/chat_controller.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/chat_history_card.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/farmassistant_button_.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/language_pop_up.dart';
import 'package:smat_crow/utils2/constants.dart';
import '../../../../utils2/colors.dart';
import '../../../../utils2/spacing_constants.dart';
import '../../../../utils2/styles.dart';

class FarmAssistantDrawer extends HookConsumerWidget {
  const FarmAssistantDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apichatHistory = ref.watch(farmAssistanceProvider).userSessionDatas;
    final farmRepositoryData = ref.watch(farmAssistanceProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                SpacingConstants.getSmatCrowSize(width: 20),
                Text(
                  chatHistory,
                  style: Styles.smatCrowMediumBody(
                    color: AppColors.SmatCrowPrimary900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.SmatCrowNeuBlue400,
                  ),
                ),
                SpacingConstants.getSmatCrowSize(
                  width: SpacingConstants.size10,
                ),
              ],
            ),
            SpacingConstants.getSmatCrowSize(height: SpacingConstants.size20),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: apichatHistory.length,
                itemBuilder: (context, index) {
                  return ChatHistoryCard(
                    isSelected: apichatHistory[index].sessionId ==
                        farmRepositoryData.selectedSession?.sessionId,
                    onDelete: (value) {
                      farmRepositoryData.deleteSessions(
                        userSession: value!,
                      );
                      Navigator.pop(context);
                    },
                    onTap: (value) {
                      farmRepositoryData.resetPlayingAudio();
                      farmRepositoryData.selectedSession = value;
                      Navigator.pop(context);
                    },
                    userSessionData: apichatHistory[index],
                  );
                },
              ),
            ),
            SpacingConstants.getSmatCrowSize(height: SpacingConstants.size20),
            CustomOutlineButton(
              onTapButton: () {
                showLanguageMenu(
                  context: context,
                  languages: farmRepositoryData.languages,
                  onSelectLanguage: (value) {
                    farmRepositoryData.selectedLanguage = value;
                  },
                );
              },
              outlineColor: AppColors.SmatCrowNeuBlue400,
              buttonWidget: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: SpacingConstants.size20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      farmRepositoryData.selectedLanguage?.languageName ?? "",
                      style: Styles.smatCrowMediumBody(
                        color: AppColors.SmatCrowPrimary900,
                      ).copyWith(
                        fontSize: SpacingConstants.font14,
                      ),
                    ),
                    SpacingConstants.getSmatCrowSize(
                      width: SpacingConstants.size10,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            SpacingConstants.getSmatCrowSize(height: SpacingConstants.size15),
            CustomOutlineButton(
              onTapButton: () {
                farmRepositoryData.createSessions();
                Navigator.pop(context);
              },
              buttonWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                  ),
                  SpacingConstants.getSmatCrowSize(
                    width: SpacingConstants.size10,
                  ),
                  Text(
                    newChat,
                    style: Styles.smatCrowMediumBody(
                      color: AppColors.SmatCrowPrimary900,
                    ).copyWith(
                      fontSize: SpacingConstants.font14,
                    ),
                  ),
                ],
              ),
            ),
            SpacingConstants.getSmatCrowSize(height: SpacingConstants.size20),
          ],
        ),
      ),
    );
  }
}

class FarmAssistantWebDrawer extends HookConsumerWidget {
  const FarmAssistantWebDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final name = useState<String?>(null);
    final apichatHistory = ref.watch(farmAssistanceProvider).userSessionDatas;
    final farmRepositoryData = ref.watch(farmAssistanceProvider);

    return Container(
      height: MediaQuery.of(context).size.height,
      constraints: const BoxConstraints(
        minWidth: SpacingConstants.size200,
        maxWidth: SpacingConstants.size310,
      ),
      child: Column(
        children: [
          customSizedBoxHeight(SpacingConstants.size30),
          Row(
            children: [
              SpacingConstants.getSmatCrowSize(width: SpacingConstants.size20),
              Text(
                chatHistory,
                style: Styles.smatCrowMediumBody(
                  color: AppColors.SmatCrowPrimary900,
                ),
              ),
              const Spacer(),
              SpacingConstants.getSmatCrowSize(height: SpacingConstants.size15),
              CustomOutlineButton(
                buttonWidth: SpacingConstants.size120,
                buttonHeight: SpacingConstants.size40,
                onTapButton: () {
                  farmRepositoryData.createSessions();
                },
                buttonWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                    ),
                    SpacingConstants.getSmatCrowSize(
                      width: SpacingConstants.size10,
                    ),
                    Text(
                      newChat,
                      style: Styles.smatCrowMediumBody(
                        color: AppColors.SmatCrowPrimary900,
                      ).copyWith(
                        fontSize: SpacingConstants.font14,
                      ),
                    ),
                  ],
                ),
              ),
              SpacingConstants.getSmatCrowSize(width: SpacingConstants.size10),
            ],
          ),
          SpacingConstants.getSmatCrowSize(height: SpacingConstants.size20),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: apichatHistory.length,
              itemBuilder: (context, index) {
                return ChatHistoryCard(
                  onDelete: (value) {
                    farmRepositoryData.deleteSessions(
                      userSession: value!,
                    );
                  },
                  isSelected: apichatHistory[index].sessionId ==
                      farmRepositoryData.selectedSession?.sessionId,
                  onTap: (value) {
                    farmRepositoryData.resetPlayingAudio();
                    farmRepositoryData.selectedSession = value;
                  },
                  userSessionData: apichatHistory[index],
                );
              },
            ),
          ),
          SpacingConstants.getSmatCrowSize(height: SpacingConstants.size20),
          CustomOutlineButton(
            onTapButton: () {
              showLanguageMenu(
                context: context,
                languages: farmRepositoryData.languages,
                onSelectLanguage: (value) {
                  farmRepositoryData.selectedLanguage = value;
                },
              );
            },
            outlineColor: AppColors.SmatCrowNeuBlue400,
            buttonWidget: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: SpacingConstants.size20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    farmRepositoryData.selectedLanguage?.languageName ?? "",
                    style: Styles.smatCrowMediumBody(
                      color: AppColors.SmatCrowPrimary900,
                    ).copyWith(
                      fontSize: SpacingConstants.font14,
                    ),
                  ),
                  SpacingConstants.getSmatCrowSize(
                    width: SpacingConstants.size10,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          SpacingConstants.getSmatCrowSize(height: SpacingConstants.size20),
        ],
      ),
    );
  }
}
