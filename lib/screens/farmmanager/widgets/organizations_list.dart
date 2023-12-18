import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../hive/implementation/organizations_impl.dart';
import '../farm_manager_provider.dart';

class OrganizationsList extends StatefulWidget {
  const OrganizationsList({Key? key, this.getSelectedId}) : super(key: key);
  final getSelectedId;

  @override
  State<StatefulWidget> createState() {
    return _OrganizationsListState();
  }
}

class _OrganizationsListState extends State<OrganizationsList> {
  OrganizationsImpl store = OrganizationsImpl();

  @override
  void initState() {
    super.initState();
    store.initializeOrganizationHive().whenComplete(() => store.deleteOrganizations());
    Provider.of<FarmManagerProvider>(context, listen: false).getSignedInUserOganizations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 12);
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: Provider.of<FarmManagerProvider>(context, listen: false).organizations.length,
                  itemBuilder: (context, index) {
                    return Provider.of<FarmManagerProvider>(context, listen: false).organizations[index];
                  },
                ),
              ),
            ],
          ),
        );
      },
      future: Provider.of<FarmManagerProvider>(context, listen: false).getSignedInUserOganizations(),
    );
  }
}
