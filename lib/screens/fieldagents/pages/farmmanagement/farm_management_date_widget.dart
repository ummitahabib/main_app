import 'package:flutter/cupertino.dart';

import '../../../../utils/colors.dart';
import '../../../widgets/square_button.dart';

class FarmManagerDateDialogWidget extends StatelessWidget {
  final Function(DateTime) selectedDate;

  const FarmManagerDateDialogWidget({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime selectedDate) {
              this.selectedDate(selectedDate);
            },
          ),
        ),
        SquareButton(
          backgroundColor: AppColors.shopOrange,
          press: () {
            Navigator.pop(context);
          },
          textColor: AppColors.whiteColor,
          text: 'Continue',
        ),
      ],
    );
  }
}
