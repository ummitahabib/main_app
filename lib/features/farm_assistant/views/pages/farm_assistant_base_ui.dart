import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_assistant/data/controller/chat_controller.dart';
import 'package:smat_crow/features/farm_assistant/views/pages/mobile/farm_assistant_mobile.dart.dart';
import 'package:smat_crow/features/farm_assistant/views/pages/web/farm_assistant_web.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmAssistantBaseUi extends HookConsumerWidget {
  const FarmAssistantBaseUi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          ref.read(farmAssistanceProvider).loading = true;
          await ref.read(farmAssistanceProvider).getSupportedLanguages();
          await ref.read(farmAssistanceProvider).getUserSessions();
          ref.read(farmAssistanceProvider).loading = false;
        });
        return null;
      },
      [],
    );

    return Stack(
      children: [
        const Responsive(
          mobile: FarmAssistantMobileView(),
          tablet: FarmAssistantWebView(),
          desktop: FarmAssistantWebView(),
        ),
        Visibility(
          visible: ref.watch(farmAssistanceProvider).loading,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color:
                AppColors.darkOrange.withOpacity(SpacingConstants.size0point2),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.SmatCrowNeuOrange400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
