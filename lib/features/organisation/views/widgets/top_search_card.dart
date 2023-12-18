import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_map_options.dart';
import 'package:smat_crow/screens/farmmanager/pages/farm_manager_page.dart' as fm;
import 'package:smat_crow/utils2/spacing_constants.dart';

class TopSearchCard extends HookConsumerWidget {
  const TopSearchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final site = ref.watch(siteProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(SpacingConstants.size20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!kIsWeb)
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: SpacingConstants.size32,
                    height: SpacingConstants.size32,
                    padding: const EdgeInsets.all(SpacingConstants.size6),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SpacingConstants.size100),
                      ),
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              if (!kIsWeb) customSizedBoxWidth(SpacingConstants.size10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingConstants.size10,
                    vertical: SpacingConstants.size5,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SpacingConstants.size8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search),
                      fm.CustomTextField(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (site.showSiteOptions) const SiteMapOptions()
      ],
    );
  }
}
