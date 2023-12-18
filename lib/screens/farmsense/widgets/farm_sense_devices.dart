import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/styles.dart';
import 'farm_sense_provider.dart';

class FarmSenseDevices extends StatefulWidget {
  const FarmSenseDevices({Key? key}) : super(key: key);

  @override
  _FarmSenseDevicesState createState() => _FarmSenseDevicesState();
}

class _FarmSenseDevicesState extends State<FarmSenseDevices> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;

  @override
  void initState() {
    Provider.of<FarmSenseDevicesProvider>(context, listen: false).getUserDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
        future: Provider.of<FarmSenseDevicesProvider>(context, listen: false).getUserDevices(),
        rememberFutureResult: true,
        whenDone: (obj) => ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 12);
              },
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: Provider.of<FarmSenseDevicesProvider>(context, listen: false).userDevicesListItem.length,
              itemBuilder: (context, index) {
                return Provider.of<FarmSenseDevicesProvider>(context, listen: false).userDevicesListItem[index];
              },
            ),
        whenError: (error) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Unable to load user devices"),
            ),
        whenNotDone: _showLoader(),);
  }

  Widget _showLoader() {
    return SizedBox(
        width: _screenWidth,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    height: 150,
                    width: _screenWidth,
                    decoration: Styles.containerDecoGrey(),
                  ),
                ],
              ),
            ),),);
  }
}
