import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/screens/offline/organization/offline_organizations_menu.dart';

import '../../../hive/daos/OrganizationsEntity.dart';
import '../../../hive/implementation/organizations_impl.dart';
import '../../../pandora/pandora.dart';
import '../../../utils/styles.dart';
import '../../widgets/header_text.dart';

class OfflineOrganizationProvider extends ChangeNotifier {
  OrganizationsImpl store = OrganizationsImpl();
  List<OrganizationsEntity> organizationsEntity = [];
  final Pandora _pandora = Pandora();

  String header = '';

  Widget? child;

  Widget showModalBottomSheet({
    required BuildContext context,
    bool isScrollControlled = true,
    bool isDismissible = false,
    RoundedRectangleBorder? shape,
    Clip? clipBehavior,
    SingleChildScrollView Function(dynamic context)? builder,
  }) {
    return showModalBottomSheet(
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    HeaderText(
                      text: header,
                      color: Colors.black,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _pandora.reRouteUserPop(context, '/signIn', null);
                      },
                      icon: Styles.closeIconGrey(),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Styles.divider(),
                ),
                child ?? Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> renderOfflineOrganizations(BuildContext context) async {
    final data = await store.findAllOrganizations();
    organizationsEntity = data;
    if (organizationsEntity.isNotEmpty) {
      await displayModalWithChild(
        OfflineOrganizationsMenu(organizationsEntity: organizationsEntity),
        'Your Organizations',
        context,
      );
    } else {
      _pandora.reRouteUserPop(context, '/signIn', null);
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(
          content: Text('You must to login to Sync your Organizations'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
