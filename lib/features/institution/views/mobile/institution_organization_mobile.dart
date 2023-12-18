import 'package:flutter/material.dart';
import 'package:smat_crow/features/institution/views/mobile/organization_table_mobile.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class InstitutionOrganizationMobile extends StatelessWidget {
  const InstitutionOrganizationMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(SpacingConstants.double20),
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrganizationTableMobile(),
        ],
      ),
    );
  }
}
