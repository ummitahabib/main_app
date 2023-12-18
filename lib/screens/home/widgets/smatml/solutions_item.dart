import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/network/crow/models/step.dart';
import 'package:smat_crow/utils/colors.dart';

class SolutionsItem extends StatelessWidget {
  final String? name, solution;
  final List<Steps> steps;

  const SolutionsItem({Key? key, this.name, this.solution, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.dashCardGrey.withOpacity(0.14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name ?? 'Unknown',
              style: GoogleFonts.quicksand(
                textStyle:
                    const TextStyle(color: AppColors.fieldAgentText, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              solution ?? 'Unknown',
              style: GoogleFonts.quicksand(
                textStyle:
                    const TextStyle(color: AppColors.fieldAgentText, fontSize: 12.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: steps.length,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 6,
                );
              },
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• Step ${index + 1}',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          color: AppColors.fieldAgentText,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      steps[index].name,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          color: AppColors.fieldAgentText,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      steps[index].step,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          color: AppColors.fieldAgentText,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
