import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import '../../../utils/styles.dart';
import 'offline_sites_provider.dart';

class OfflineSitesMenu extends StatefulWidget {
  final String organizationId;

  const OfflineSitesMenu({Key? key, required this.organizationId}) : super(key: key);

  @override
  _OfflineSitesMenuState createState() => _OfflineSitesMenuState();
}

class _OfflineSitesMenuState extends State<OfflineSitesMenu> {
  final Pandora _pandora = Pandora();

  @override
  Widget build(BuildContext context) {
    return Provider.of<OfflineSitesProvider>(context, listen: false).enhancedFutureBuilder(context);
  }

  @override
  void initState() {
    super.initState();
    _pandora.getFromSharedPreferences('email').then((value) {
      Provider.of<OfflineSitesProvider>(context, listen: false).email = value;
    });
    _pandora.getFromSharedPreferences('password').then((value) {
      Provider.of<OfflineSitesProvider>(context, listen: false).pass = value;
    });
    Provider.of<OfflineSitesProvider>(context, listen: false)
        .store
        .initializeSiteHive()
        .whenComplete(() => Provider.of<OfflineSitesProvider>(context, listen: false).renderOfflineSites(context));
  }
}

class ReuseableWidget extends StatelessWidget {
  const ReuseableWidget({
    Key? key,
    double? screenWidth,
  })  : _screenWidth = screenWidth,
        super(key: key);

  final double? _screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: _screenWidth,
      decoration: Styles.containerDecoGrey(),
    );
  }
}
