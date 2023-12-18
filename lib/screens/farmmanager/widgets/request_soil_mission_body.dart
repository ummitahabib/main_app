import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:smat_crow/network/crow/models/request/create_star_mission_request.dart';
import 'package:smat_crow/network/crow/star_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/widgets/old_text_field.dart';
import 'package:smat_crow/screens/widgets/square_button.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/strings.dart';

import '../../../utils/styles.dart';

class RequestSoilMissionBody extends StatefulWidget {
  const RequestSoilMissionBody({Key? key, required this.siteId, required this.organizationId}) : super(key: key);
  final String siteId, organizationId;

  @override
  _RequestSoilMissionBodyState createState() => _RequestSoilMissionBodyState();
}

class _RequestSoilMissionBodyState extends State<RequestSoilMissionBody> {
  TextEditingController missionName = TextEditingController();
  TextEditingController missionDescription = TextEditingController();
  late ScrollDatePicker controller;
  DateTime _selectedDate = DateTime.now();
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    controller = ScrollDatePicker(
      minimumDate: DateTime(2011),
      maximumDate: DateTime(2050),
      selectedDate: _selectedDate,
      locale: const Locale('en'),
      onDateTimeChanged: (DateTime value) {
        setState(() {
          _selectedDate = value;
        });
      },
    );
    // initialDateTime: DateTime.now(), minYear: 2011, maxYear: 2050);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            TextInputContainer(
              child: TextField(
                autocorrect: false,
                controller: missionName,
                keyboardType: TextInputType.name,
                style: Styles.nunitoRegularStyle(),
                decoration: InputDecoration(
                  hintText: "Mission Name",
                  border: InputBorder.none,
                  hintStyle: Styles.nunitoRegularStyle(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextInputContainer(
              child: TextField(
                autocorrect: false,
                controller: missionDescription,
                maxLines: 4,
                maxLength: 60,
                keyboardType: TextInputType.multiline,
                style: Styles.nunitoRegularStyle(),
                decoration: InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                  hintStyle: Styles.nunitoRegularStyle(),
                ),
              ),
            ),
/*
          ScrollDatePicker(
            controller: _controller,
            locale: DatePickerLocale.en_us,
            pickerDecoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.landingOrangeButton, width: 2.0),
                borderRadius: BorderRadius.circular(30)),
            config: DatePickerConfig(
              isLoop: true,
              selectedTextStyle: TextStyle(
                color: AppColors.signupSubHeaderGrey,
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'NunitoSans_Regular',
              ),
            ),
            onChanged: (value) {
              setState(() {
                _selectedDate = value;
              });
            },
          ),
*/
            const SizedBox(
              height: 20,
            ),
            SquareButton(
              backgroundColor: AppColors.landingOrangeButton,
              press: () {
                _pandora.logAPPButtonClicksEvent('REQUEST_NEW_SOIL_MISSION_BUTTON_CLICKED');

                if (validateInputs(missionName.text, missionDescription.text)) {
                  requestSoilTestMission();
                } else {
                  _pandora.showToast(
                    Errors.missingFieldsError,
                    context,
                    MessageTypes.WARNING.toString().split('.').last,
                  );
                }
              },
              textColor: AppColors.landingWhiteButton,
              text: 'Request Mission',
            ),
          ],
        ),
      ),
    );
  }

  bool validateInputs(String name, String description) {
    return (name.isEmpty || description.isEmpty) ? false : true;
  }

  Future<void> requestSoilTestMission() async {
    final requestMission = await requestMissionForSite(
      CreateMissionRequest(
        name: missionName.text,
        description: missionDescription.text,
        organization: widget.organizationId,
        site: widget.siteId,
        scheduleDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
      ),
    );

    if (requestMission) {
      Navigator.pop(context);
      _pandora.showToast('New Mission Requested', context, MessageTypes.SUCCESS.toString().split('.').last);
    } else {
      _pandora.showToast('Failed to request Mission', context, MessageTypes.FAILED.toString().split('.').last);
    }
  }
}
