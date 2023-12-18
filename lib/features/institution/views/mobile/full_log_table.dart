import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/log_type_table_mobile.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

int _page = 1;

class FullLogTable extends HookConsumerWidget {
  const FullLogTable({
    super.key,
    required this.log,
  });
  final List<LogDetailsResponse> log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = useState("");
    final controller = useScrollController();
    final logController = ref.watch(logProvider);
    useEffect(
      () {
        controller.addListener(() async {
          if (controller.position.atEdge) {
            final isTop = controller.position.pixels == 0;
            if (!isTop && !logController.loadMore) {
              await logController.getMoreOrgLogs(
                queries: {
                  "logTypeName": ref.read(sharedProvider).logType!.types,
                  "logStatusName": log.first.log!.status,
                  "page": _page
                },
              );
              _page++;
            }
          }
        });
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(context, title: log.isEmpty ? "Logs" : "${log.first.log!.status ?? ""} Logs"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        controller: controller,
        child: Column(
          children: [
            CustomTextField(
              hintText: "Search",
              text: "",
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.SmatCrowNeuBlue900,
              ),
              onChanged: (value) {
                search.value = value;
              },
            ),
            const Ymargin(SpacingConstants.double20),
            LogTypeTableMobile(
              log: log
                  .where((element) => element.log!.name!.toLowerCase().contains(search.value..toLowerCase()))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
