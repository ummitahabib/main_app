import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmAssistantAppBar extends StatefulWidget {
  const FarmAssistantAppBar({
    required this.resetAudio,
    super.key,
  });
  final Function() resetAudio;

  @override
  State<FarmAssistantAppBar> createState() => _FarmAssistantAppBarState();
}

class _FarmAssistantAppBarState extends State<FarmAssistantAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            size: 25,
          ),
        ),
        SpacingConstants.getSmatCrowSize(width: SpacingConstants.size10),
        Text(
          farmAssistant,
          style: Styles.smatCrowMediumBody(
            color: AppColors.SmatCrowPrimary900,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            if (kIsWeb) {
              context.beamToReplacementNamed(
                ConfigRoute.homeDashborad,
              );
            } else {
              Navigator.pop(context);
            }
            widget.resetAudio();
          },
          icon: const Icon(
            Icons.close,
            color: AppColors.SmatCrowNeuBlue400,
          ),
        ),
      ],
    );
  }
}
