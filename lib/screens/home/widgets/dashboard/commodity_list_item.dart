import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/utils/colors.dart';

class CommodityPriceListItem extends StatelessWidget {
  final commodity;
  final market;
  final state;
  final pricePerTon;
  final percentage;

  const CommodityPriceListItem({Key? key, this.commodity, this.market, this.state, this.pricePerTon, this.percentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      elevation: 0.1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commodity,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: AppColors.fieldAgentText,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.pin_drop_outlined,
                          color: AppColors.shopOrange,
                          size: 10,
                        ),
                        Text(
                          state,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColors.fieldAgentText,
                              fontWeight: FontWeight.normal,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(
                          Icons.pin_drop_outlined,
                          size: 10,
                          color: AppColors.shopOrange,
                        ),
                        Text(
                          market,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColors.fieldAgentText,
                              fontWeight: FontWeight.normal,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₦ $pricePerTon',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: AppColors.fieldAgentText,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  percentage,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: (percentage.toString().contains('+'))
                          ? Colors.green
                          : (percentage.toString().contains('-'))
                              ? Colors.red
                              : AppColors.fieldAgentText,
                    ),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
