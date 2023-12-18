import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/screens/subscription/pages/statistics_page.dart';
import 'package:smat_crow/utils2/responsive.dart';

import '../../../network/crow/models/subcription/subscription.dart';
import '../../../pandora/pandora.dart';
import '../../../utils/styles.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key, required this.subscriptions}) : super(key: key);

  final List<Subscription> subscriptions;

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => customDialogAndModal(
                  context,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ModalStick(),
                        const Ymargin(30),
                        BoldHeaderText(text: subscriptions.first.plan!.name ?? ""),
                        const Ymargin(20),
                        DetailItem(
                          title: "Amount",
                          value:
                              "NGN ${Pandora().newMoneyFormat((subscriptions.first.plan!.amount ?? 0.0).toDouble())}",
                        ),
                        const Ymargin(15),
                        DetailItem(
                          title: "Subscription Code",
                          value: subscriptions.first.plan!.planCode ?? "",
                        ),
                        const Ymargin(15),
                        DetailItem(
                          title: "Started",
                          value: DateFormat.yMMMd().format(subscriptions.first.started ?? DateTime.now()),
                        ),
                        const Ymargin(15),
                        DetailItem(
                          title: "Payments",
                          value: subscriptions.first.payments.toString(),
                        ),
                        const Ymargin(15),
                        DetailItem(
                          title: "Next Charge",
                          value: DateFormat.yMMMd().format(subscriptions.first.nextCharge ?? DateTime.now()),
                        ),
                        const Ymargin(30),
                        CustomButton(
                          text: "Close",
                          onPressed: () {
                            if (Responsive.isDesktop(context)) {
                              OneContext().popDialog();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                        const Ymargin(50),
                      ],
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  margin: const EdgeInsets.only(bottom: 5.0),
                  decoration: Styles.boxDecoWhite12(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '#${subscriptions[index].plan!.id}',
                            style: const TextStyle(
                              color: Color(0xFF6B7380),
                              fontSize: 10,
                              fontFamily: 'Basier Circle',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Ymargin(10),
                          Text(
                            subscriptions[index].plan!.name!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Ymargin(10),
                          Text(
                            "NGN ${pandora.newMoneyFormat((subscriptions[index].plan!.amount ?? 0).toDouble())}",
                            style: const TextStyle(
                              color: Color(0xFFFF9D00),
                              fontSize: 12,
                              fontFamily: 'Basier Circle',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Text(
                          "${DateFormat.yMMMd().format(subscriptions.first.started ?? DateTime.now())} -\n${DateFormat.yMMMd().format(subscriptions.first.nextCharge ?? DateTime.now())}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF6B7380),
                            fontSize: 12,
                            fontFamily: 'Basier Circle',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Row _planInfoListItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Color(0xFF6E7191)),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value),
          ],
        ),
      ],
    );
  }
}
