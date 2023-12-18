import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/utils/colors.dart';

class CommodityPriceSmallItem extends StatelessWidget {
  final commodity;
  final date;
  final type;
  final pricePerTon;
  final percentage;

  const CommodityPriceSmallItem({Key? key, this.commodity, this.date, this.type, this.pricePerTon, this.percentage})
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
          width: 130,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$commodity',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: AppColors.fieldAgentText,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.pin_drop_outlined,
                          color: AppColors.shopOrange,
                          size: 10,
                        ),
                        Text(
                          type.toString().split('.').last,
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
                      ],
                    ),
                    const SizedBox(
                      height: 5,
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
                    const SizedBox(
                      height: 7,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '$percentage %',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: (type.toString().split('.').last.contains('BUY'))
                                ? Colors.green
                                : (type.toString().split('.').last.contains('SELL'))
                                    ? Colors.red
                                    : AppColors.fieldAgentText,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
