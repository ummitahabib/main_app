import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fieldagents_providers/field_agent_org_provider.dart';

class FieldAgentsOrganizationsList extends StatefulWidget {
  final String fieldAgentId;

  const FieldAgentsOrganizationsList({Key? key, required this.fieldAgentId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FieldAgentsOrganizationsListState();
  }
}

class _FieldAgentsOrganizationsListState extends State<FieldAgentsOrganizationsList> {
  @override
  void initState() {
    super.initState();
    Provider.of<FieldAgentOrgProvider>(context, listen: false).getOrganizationsForFieldAgent(widget.fieldAgentId);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<FieldAgentOrgProvider>(context, listen: false).fieldAgentOrgContainer(widget.fieldAgentId);
  }
}
