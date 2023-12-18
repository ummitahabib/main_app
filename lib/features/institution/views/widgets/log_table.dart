import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/log_type_table_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/web/log_type_table_web.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/colored_container.dart';
import 'package:smat_crow/features/institution/views/mobile/full_log_table.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class LogTable extends HookConsumerWidget {
  const LogTable({
    super.key,
    required this.color,
    required this.text,
    required this.log,
  });

  final Color color;
  final String text;
  final List<LogDetailsResponse> log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (log.where((element) => element.log!.status!.toLowerCase() == text.toLowerCase()).toList().isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColoredContainer(color: color, text: text.toUpperCase(), verticalPadding: SpacingConstants.font10),
            InkWell(
              onTap: () {
                if (kIsWeb) {
                  final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
                  final id = beamState.pathPatternSegments;
                  final path = beamState.queryParameters;
                  Pandora().reRouteUser(
                    context,
                    "${ConfigRoute.farmLogTable}/${id.last}?logTypeName=${path['logTypeName']}&logStatusName=$text",
                    path['logTypeName'],
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullLogTable(
                        log: log.where((element) => element.log!.status!.toLowerCase() == text.toLowerCase()).toList(),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                viewAllText,
                style: Styles.smatCrowSubRegularUnderline(color: AppColors.SmatCrowNeuBlue500),
              ),
            )
          ],
        ),
        const Ymargin(SpacingConstants.double20),
        Responsive(
          mobile: LogTypeTableMobile(
            log: log.where((element) => element.log!.status!.toLowerCase() == text.toLowerCase()).toList(),
          ),
          tablet: LogTypeTableMobile(
            log: log.where((element) => element.log!.status!.toLowerCase() == text.toLowerCase()).toList(),
          ),
          desktop: LogTypeTableWeb(
            logList: log.where((element) => element.log!.status!.toLowerCase() == text.toLowerCase()).toList(),
          ),
          desktopTablet: LogTypeTableWeb(
            logList: log.where((element) => element.log!.status!.toLowerCase() == text.toLowerCase()).toList(),
          ),
        ),
        const Ymargin(SpacingConstants.size40),
      ],
    );
  }
}
