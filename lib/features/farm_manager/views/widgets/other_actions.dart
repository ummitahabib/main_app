import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmManagerOtherActions extends HookConsumerWidget {
  const FarmManagerOtherActions({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);

    if (shared.userInfo != null && shared.userInfo!.user.role.role == UserRole.user.name) {
      return const SizedBox.shrink();
    }

    useEffect(
      () {
        Future(() {
          if (kIsWeb) {
            final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
            final id = beamState.pathPatternSegments;

            if (shared.flagList.isEmpty) {
              shared.getFlags(orgId: id.last);
            }
          } else {
            if (shared.flagList.isEmpty) {
              shared.getFlags();
            }
          }
        });
        return null;
      },
      [],
    );
    if (shared.flagList.isEmpty) {
      return const SizedBox.shrink();
    }
    if (!shared.flagList.map((e) => (e.flag ?? "").toLowerCase()).contains("purchases") &&
        !shared.flagList.map((e) => (e.flag ?? "").toLowerCase()).contains("sales") &&
        !shared.flagList.map((e) => (e.flag ?? "").toLowerCase()).contains("expense")) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const BoldHeaderText(
          text: otherActionsText,
          fontSize: SpacingConstants.font18,
        ),
        const Ymargin(SpacingConstants.size20),
        AppContainer(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (shared.flagList.map((e) => (e.flag ?? "").toLowerCase()).contains("purchases"))
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      purchasesText,
                      style: Styles.smatCrowSubParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue600,
                      ),
                    ),
                  ),
                  trailing: TextButton.icon(
                    onPressed: () {
                      ref.read(logProvider).logResponse = null;
                      Pandora().reRouteUser(
                        context,
                        ConfigRoute.registerFarmLog,
                        emptyString,
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.SmatCrowPrimary500,
                    ),
                    label: Text(
                      logPurchasesText,
                      style: Styles.smatCrowSubParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue600,
                      ),
                    ),
                  ),
                ),
              if (shared.flagList.map((e) => (e.flag ?? "").toLowerCase()).contains("purchases")) const Divider(),
              if (shared.flagList.map((e) => (e.flag ?? "").toLowerCase()).contains("expense"))
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      expensesText,
                      style: Styles.smatCrowSubParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue600,
                      ),
                    ),
                  ),
                  trailing: TextButton.icon(
                    onPressed: () {
                      ref.read(logProvider).logResponse = null;
                      Pandora().reRouteUser(
                        context,
                        ConfigRoute.registerFarmLog,
                        emptyString,
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.SmatCrowPrimary500,
                    ),
                    label: Text(
                      logExpenseText,
                      style: Styles.smatCrowSubParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue600,
                      ),
                    ),
                  ),
                ),
              if (shared.flagList.map((e) => (e.flag ?? "").toLowerCase()).contains("expenses")) const Divider(),
              if (shared.flagList.map((e) => (e.flag ?? "").toLowerCase()).contains("sales"))
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      salesText,
                      style: Styles.smatCrowSubParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue600,
                      ),
                    ),
                  ),
                  trailing: TextButton.icon(
                    onPressed: () {
                      ref.read(logProvider).logResponse = null;
                      Pandora().reRouteUser(
                        context,
                        ConfigRoute.registerFarmLog,
                        "args",
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.SmatCrowPrimary500,
                    ),
                    label: Text(
                      logSalesText,
                      style: Styles.smatCrowSubParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
