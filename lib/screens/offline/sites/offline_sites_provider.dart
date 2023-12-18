import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

import '../../../hive/daos/SitesEntity.dart';
import '../../../hive/implementation/sites_impl.dart';
import '../../../network/crow/crow_authentication.dart';
import '../../../network/crow/models/request/create_site.dart';
import '../../../network/crow/sites_operations.dart';
import '../../../pandora/pandora.dart';
import '../../../utils/assets/nsvgs_assets.dart';
import '../../../utils/assets/svgs_assets.dart';
import '../../../utils/session.dart';
import '../../../utils/styles.dart';
import '../../widgets/header_text.dart';
import 'offline_sites_list_item.dart';
import 'offline_sites_menu.dart';

class OfflineSitesProvider extends ChangeNotifier {
  SitesImpl store = SitesImpl();
  List<SitesEntity> sitesEntity = [];
  List<Widget> sitesItem = [];
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  final Pandora _pandora = Pandora();
  String email = '', pass = '';

  bool get mounted => false;

  Future<void> renderOfflineSites(BuildContext context) async {
    return _asyncMemoizer.runOnce(() async {
      var widget;
      final data = await store.findAllSitesByOrganization(widget.organizationId);
      List<Widget> sitesItem = [];

      sitesEntity = data;
      for (final item in sitesEntity) {
        sitesItem.add(OfflineSitesListItem(sitesEntity: item, background: Colors.white));
      }
      sitesItem.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (sitesEntity.isNotEmpty)
              Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      SvgsAssets.kSyncCloud,
                    ),
                    iconSize: 45,
                    onPressed: () {
                      synchronizeSitesWithCloud(context);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Sync Sites', style: Styles.semiBoldTextStyleBlack()),
                ],
              )
            else
              const SizedBox(),
            Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    NsvgsAssets.kLoginFab,
                  ),
                  iconSize: 45,
                  onPressed: () {
                    _pandora.reRouteUser(
                      context,
                      '/createSite-Offline',
                      CreateSiteSectorArgs(
                        widget.organizationId,
                        'siteId',
                        true,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Add Site',
                  style: Styles.semiBoldTextStyleBlack(),
                ),
              ],
            )
          ],
        ),
      );

      if (mounted) {
        sitesItem = sitesItem;
        notifyListeners();
      }

      return sitesEntity;
    });
  }

  Future<void> synchronizeSitesWithCloud(BuildContext context) async {
    await Provider.of<CrowAuthentication>(context, listen: false)
        .loginIntoAccount(context, email, pass)
        .whenComplete(() {
      debugPrint(Session.FirebaseId);
      debugPrint(Session.SessionToken);
      sync(context);
    });
  }

  Future<void> sync(BuildContext context) async {
    if (sitesEntity.isNotEmpty) {
      for (final element in sitesEntity) {
        final CreateSiteRequest createSiteRequest = CreateSiteRequest(
          name: element.name,
          organization: element.organizationId,
          geoJson: element.geojson,
          polygonId: "0",
        );

        final createSite = await createSiteForOrganization(createSiteRequest);
        if (createSite) {
          await store.deleteSitesById(element.key);
          await OneContext().showSnackBar(
            builder: (_) => const SnackBar(
              content: Text('Site Created'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          await OneContext().showSnackBar(
            builder: (_) => SnackBar(
              content: Text('Failed to Create ${element.name}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        await OneContext().showSnackBar(
          builder: (_) => const SnackBar(
            content: Text('Upload Completed'),
            backgroundColor: Colors.green,
          ),
        );
        _pandora.reRouteUserPop(context, '/signIn', null);
      }
    } else {}
  }

  Widget enhancedFutureBuilder(BuildContext context) {
    return EnhancedFutureBuilder(
      future: renderOfflineSites(context),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load soil samples"),
      ),
      whenNotDone: _showLoader(),
    );
  }

  Widget _showLoader() {
    return SizedBox(
      width: _screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ReuseableWidget(screenWidth: _screenWidth),
              const SizedBox(
                height: 10,
              ),
              ReuseableWidget(screenWidth: _screenWidth),
              const SizedBox(
                height: 10,
              ),
              ReuseableWidget(screenWidth: _screenWidth),
              const SizedBox(
                height: 10,
              ),
              // Container(
              //   height: 150,
              //   width: _screenWidth,
              //   decoration: Styles.containerDecoGrey(),
              // ),
              ReuseableWidget(screenWidth: _screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showResponse() {
    return ListView.builder(
      itemCount: sitesItem.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return sitesItem[index];
      },
    );
  }

  Future showModalButtonSheet(Widget child, String header, BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
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
                        Navigator.pop(context);
                      },
                      icon: Styles.closeIconGrey(),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    height: 1.0,
                  ),
                ),
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
