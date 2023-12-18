import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/pages/organisation.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/network/crow/models/organization_by_id_response.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class OrganizationMoreOption extends StatefulHookConsumerWidget {
  const OrganizationMoreOption({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrganizationMoreOptionState();
}

class _OrganizationMoreOptionState extends ConsumerState<OrganizationMoreOption> {
  late OrganizationNotifier organizationNotifier;
  @override
  void didChangeDependencies() {
    organizationNotifier = ref.read(organizationProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: kIsWeb ? SpacingConstants.size342 : null,
            padding: const EdgeInsets.symmetric(vertical: SpacingConstants.size10),
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(SpacingConstants.size16)),
            child: Column(
              children: [
                ListTile(
                  title: Center(
                    child: Text(
                      "$edit $organizationText",
                      style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                    ),
                  ),
                  onTap: () {
                    ref.read(organizationProvider).visible = false;
                    addNewOrganization(
                      context,
                      org: ref.read(organizationProvider).organization,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Center(
                    child: Text(
                      "$delete $organizationText",
                      style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowRed500),
                    ),
                  ),
                  onTap: () {
                    organizationNotifier.visible = false;
                    deleteOrganization(context, ref.read(organizationProvider).organization!);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: InkWell(
              onTap: () => ref.read(organizationProvider).visible = false,
              child: Container(
                width: kIsWeb ? 340 : Responsive.xWidth(context),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Text(
                    cancel,
                    style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> deleteOrganization(BuildContext context, GetOrganizationById org) {
  return OneContext().showDialog(
    builder: (cxt) => HookConsumer(
      builder: (context, ref, child) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpacingConstants.size16),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(SpacingConstants.size16),
            ),
            width: kIsWeb ? SpacingConstants.size342 : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(SpacingConstants.size40),
                  child: Center(
                    child: Text(
                      deleteConfirmation + org.name!,
                      style: Styles.smatCrowBodyRegular(
                        color: AppColors.SmatCrowNeuBlue900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomButton(
                      text: "$no, $cancel",
                      width: kIsWeb ? SpacingConstants.size159 : Responsive.xWidth(context, percent: 0.35),
                      height: 55,
                      onPressed: () => OneContext().popDialog(),
                      textColor: AppColors.SmatCrowNeuBlue500,
                    ),
                    const SizedBox(height: SpacingConstants.size55, child: VerticalDivider()),
                    CustomButton(
                      width: kIsWeb ? SpacingConstants.size159 : Responsive.xWidth(context, percent: 0.35),
                      height: SpacingConstants.size55,
                      text: "$yes, $delete",
                      onPressed: () {
                        ref.read(organizationProvider).deleteOrganization(org.id ?? "").then((value) {
                          if (value) {
                            OneContext().popDialog();
                          }
                        });
                      },
                      color: Colors.transparent,
                      textColor: AppColors.SmatCrowRed500,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    ),
  );
}
