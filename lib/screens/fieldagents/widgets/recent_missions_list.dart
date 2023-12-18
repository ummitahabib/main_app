import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/loader_tile.dart';
import 'package:smat_crow/screens/widgets/old_text_field.dart';
import '../../../utils/styles.dart';
import '../fieldagents_providers/agent_mission_provider.dart';
import 'missions_item.dart';

class AgentMissionsList extends StatefulWidget {
  final String fieldAgentId;

  const AgentMissionsList({Key? key, required this.fieldAgentId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AgentMissionsListState();
  }
}

class _AgentMissionsListState extends State<AgentMissionsList> {
  String? _missionFilter;
  final List<String> _missionTypes = ['All', 'Assigned', 'Completed'];
  List<Widget> _filteredData = [];
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    Provider.of<AgentMissionProvider>(context, listen: false).getMissionsForAgent(widget.fieldAgentId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentMissionProvider>(
      builder: (context, provider, _) {
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
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
                        Text('Missions', style: GoogleFonts.poppins(textStyle: Styles.bTextStyle())),
                        const Spacer(),
                        SizedBox(
                          width: 150,
                          child: TextInputContainer(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String?>(
                                hint: const Text('All'),
                                // Not necessary for Option 1
                                value: _missionFilter,

                                style: GoogleFonts.poppins(textStyle: Styles.TextStyleField()),
                                onChanged: (newValue) {
                                  _filteredData = [];
                                  if (newValue != null) {
                                    setState(() {
                                      _missionFilter = newValue;
                                      for (int i = 0; i < provider.getMissionsData.length; i++) {
                                        if (_pandora.capitalizeFirstLetter(provider.getMissionsData[i].progress!) ==
                                            _missionFilter) {
                                          _filteredData.add(
                                            MissionsItem(
                                              missionStatus: provider.getMissionsData[i].progress!,
                                              assignedDate: provider.getMissionsData[i].createdAt!,
                                              missionTitle: provider.getMissionsData[i].name!,
                                              siteId: provider.getMissionsData[i].site!,
                                              missionId: provider.getMissionsData[i].id!,
                                            ),
                                          );
                                        } else if (_missionFilter == "All") {
                                          _filteredData.add(
                                            MissionsItem(
                                              missionStatus: provider.getMissionsData[i].progress!,
                                              assignedDate: provider.getMissionsData[i].createdAt!,
                                              missionTitle: provider.getMissionsData[i].name!,
                                              siteId: provider.getMissionsData[i].site!,
                                              missionId: provider.getMissionsData[i].id!,
                                            ),
                                          );
                                        }
                                        if (mounted) {
                                          setState(() {
                                            provider.recentMissionsItem = _filteredData;
                                          });
                                        }
                                      }
                                    });
                                  }
                                },
                                items: _missionTypes.map((location) {
                                  return DropdownMenuItem(
                                    value: location,
                                    child: Text(location),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: provider.recentMissionsItem.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Align(alignment: Alignment.topCenter, child: provider.recentMissionsItem[index]);
                    },
                  )
                ],
              ),
            );
          },
          future: provider.getMissionsForAgent(widget.fieldAgentId),
        );
      },
    );
  }
}
