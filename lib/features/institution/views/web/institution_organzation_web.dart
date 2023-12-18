import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/views/mobile/side_menu.dart';
import 'package:smat_crow/features/institution/views/web/organization_table_web.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class InstitutionOrganizationWeb extends StatelessWidget {
  const InstitutionOrganizationWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SpacingConstants.double20),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BoldHeaderText(
                text: organizationText,
                fontSize: SpacingConstants.font24,
              ),
              CustomButton(
                text: "Add New Organization",
                onPressed: () {
                  inviteOrganization(context);
                },
                leftIcon: Icons.add,
                width: SpacingConstants.size213,
              )
            ],
          ),
          const Ymargin(SpacingConstants.double20),
          const OrganizationTableWeb()
        ],
      ),
    );
  }
}
