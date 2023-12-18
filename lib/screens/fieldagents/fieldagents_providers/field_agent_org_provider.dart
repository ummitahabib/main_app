import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/screens/farmmanager/widgets/loader_tile.dart';

import '../../../network/crow/farm_manager_operations.dart';
import '../../../network/crow/models/farm_management/agent/generic_field_agent_organizations.dart';
import '../../../utils/styles.dart';
import '../../widgets/empty_list_item.dart';
import '../widgets/field_agents_organizations_item.dart';

class FieldAgentOrgProvider extends ChangeNotifier {
  bool loading = true;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  List<Widget> fieldAgentOrganizationsItem = [];
  FieldAgentOrganization? fieldAgentsOrganizations;

  bool get mounted => false;

  Widget fieldAgentOrgContainer(String fieldAgentId) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 9),
            child: LoaderTileLarge(),
          );
        }
        return Container(
          margin: const EdgeInsets.only(left: 22, right: 22, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Text(
                      'Assigned Organizations',
                      style: GoogleFonts.poppins(
                        textStyle: Styles.boldMinTextStyle(),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: fieldAgentOrganizationsItem.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: fieldAgentOrganizationsItem[index],
                  );
                },
              )
            ],
          ),
        );
      },
      future: getOrganizationsForFieldAgent(fieldAgentId),
    );
  }

  Future getOrganizationsForFieldAgent(String agentId) async {
    return _asyncMemoizer.runOnce(() async {
      final data = await getFieldAgentOrganizations(agentId);
      fieldAgentsOrganizations = data;
      List<Widget> organizationsItem = [];
      if (data!.data.isEmpty) {
        organizationsItem.add(const EmptyListItem(message: 'You do not have any Organizations'));
      } else {
        for (final mission in fieldAgentsOrganizations!.data) {
          organizationsItem.add(
            FieldAgentsOrganizationsItem(
              organizationId: mission.organizationId!,
              createdDate: mission.createdDate!,
              organizationName: mission.organizationName!,
            ),
          );
        }
      }

      if (mounted) {
        fieldAgentOrganizationsItem = organizationsItem;
        notifyListeners();
      }
      return data;
    });
  }
}
