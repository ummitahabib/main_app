import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../../pandora/pandora.dart';
import '../../../utils/styles.dart';
import '../fieldagents_providers/all_plants_item_provider.dart';

class AllPlantsItem extends StatefulWidget {
  const AllPlantsItem({Key? key, required this.plantId}) : super(key: key);
  final String plantId;

  @override
  _AllPlantsItemState createState() => _AllPlantsItemState();
}

class _AllPlantsItemState extends State<AllPlantsItem> {
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    Provider.of<AllPlantsItemProvider>(context, listen: false).fetchPlantDetails(widget.plantId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllPlantsItemProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none  ||
                snapshot.connectionState == ConnectionState.waiting) {}
            return InkWell(
              onTap: () {
                _pandora.logAPPButtonClicksEvent('ALL_PLANTS_ITEM_CLICKED');
                _pandora.reRouteUser(context, ConfigRoute.plantDetails, widget.plantId);
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                color: Colors.white,
                elevation: 1,
                shadowColor: Colors.black.withOpacity(0.6),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Image.network(
                            provider.imageUrl,
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(provider.defaultImage, height: 70, width: 70, fit: BoxFit.cover);
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                provider.plantName,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: GoogleFonts.poppins(
                                  textStyle: Styles.textStyleBlueGreyMd(),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                provider.plantBotanicalName,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: GoogleFonts.poppins(
                                  textStyle: Styles.textStyleBlueGreySm(),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                provider.plantDescription,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                  textStyle: Styles.textStyleBlueSm(),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          future: provider.fetchPlantDetails(widget.plantId),
        );
      },
    );
  }
}
