import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/screens/fieldagents/pages/farmmanagement/fam_management_select_asset_status_menu.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../network/crow/models/farm_management/assets/generic_asset_details.dart';
import '../../../../network/crow/models/request/farm_management/create_asset.dart';
import '../../../../pandora/pandora.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/header_text.dart';
import '../../../widgets/square_button.dart';
import '../../../widgets/sub_header_text.dart';
import '../../widgets/farm_manager_input_dropdown_widget.dart';
import 'fam_management_select_asset_types_menu.dart';
import 'fam_management_select_flags_menu.dart';
import 'farm_management_date_widget.dart';

class AddFarmManagerAssetPage extends StatefulWidget {
  final AddLogAssetPageArgs addAssetPageArgs;

  const AddFarmManagerAssetPage({Key? key, required this.addAssetPageArgs}) : super(key: key);

  @override
  _AddFarmManagerAssetPageState createState() {
    return _AddFarmManagerAssetPageState();
  }
}

class _AddFarmManagerAssetPageState extends State<AddFarmManagerAssetPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _assetName,
      _assetType,
      _assetFlag,
      _assetStatus,
      _purchaseDate,
      _manufactureDate,
      _expiryDate,
      _assetQuantity,
      _assetSerial,
      _assetManufacturer,
      _assetCost,
      _assetNotes,
      _assetModel,
      _cropFamily,
      _buildingType,
      _transplantAfter,
      _matureAfter;

  /// Editable Inputs
  final TextEditingController _assetNameController = TextEditingController();
  final TextEditingController _assetQuantityController = TextEditingController();
  final TextEditingController _assetSerialController = TextEditingController();
  final TextEditingController _assetManufacturerController = TextEditingController();
  final TextEditingController _assetCostController = TextEditingController();
  final TextEditingController _assetNotesController = TextEditingController();
  final TextEditingController _assetModelController = TextEditingController();
  final TextEditingController _assetCropFamilyController = TextEditingController();
  final TextEditingController _assetBuildingTypeController = TextEditingController();
  final TextEditingController _assetTransplantAfterController = TextEditingController();
  final TextEditingController _assetMatureAfterController = TextEditingController();

  ///End of section

  final TextEditingController _assetTypeController = TextEditingController();
  final TextEditingController _assetFlagController = TextEditingController();
  final TextEditingController _assetStatusController = TextEditingController();
  final TextEditingController _assetPurchaseDateController = TextEditingController();
  final TextEditingController _assetManufactureDateController = TextEditingController();
  final TextEditingController _assetExpiryDateController = TextEditingController();
  DateTime? purchaseDate, manufactureDate, expiryDate;
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    if (!widget.addAssetPageArgs.isNewInput) {
      setState(() {
        _assetNameController.text = widget.addAssetPageArgs.details!.asset!.name ?? "";
        _assetQuantityController.text = "${widget.addAssetPageArgs.details!.asset!.quantity ?? ""}";
        _assetSerialController.text = widget.addAssetPageArgs.details!.asset!.serialnumber ?? "";
        _assetManufacturerController.text = widget.addAssetPageArgs.details!.asset!.manufacturer ?? "";
        _assetCostController.text = "${widget.addAssetPageArgs.details!.asset!.cost ?? ""}";
        _assetNotesController.text = widget.addAssetPageArgs.details!.asset!.notes ?? "";
        _assetModelController.text = widget.addAssetPageArgs.details!.asset!.model ?? "";
        _assetCropFamilyController.text = widget.addAssetPageArgs.details!.asset!.cropFamily ?? "";
        _assetBuildingTypeController.text = widget.addAssetPageArgs.details!.asset!.type ?? "";
        _assetTransplantAfterController.text = "${widget.addAssetPageArgs.details!.asset!.daysToTransplant ?? ""}";
        _assetMatureAfterController.text = "${widget.addAssetPageArgs.details!.asset!.daysToMaturity ?? ""}";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.farmManagerBackground,
        elevation: 0.1,
      ),
      backgroundColor: AppColors.farmManagerBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeaderText(
                          text: (widget.addAssetPageArgs.isNewInput) ? 'Register Asset' : 'Update Asset',
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          EvaIcons.settings2Outline,
                          size: 20,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SubHeaderText(
                      text: (widget.addAssetPageArgs.isNewInput)
                          ? 'Register your newly acquired farm Asset'
                          : 'Update your draft farm Asset',
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: formUI(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return Card(
      elevation: 0.2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.offWhite,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              style: Styles.inputStyle(),
              controller: _assetNameController,
              decoration: InputDecoration(
                label: const Text("Asset Name"),
                errorBorder: Styles.errorBorder(),
                focusedBorder: Styles.focusBorder(),
                border: Styles.border(),
              ),
              validator: (arg) {
                if (isEmpty(arg)) {
                  return 'Asset Name cannot be empty';
                } else {
                  return null;
                }
              },
              onSaved: (val) {
                _assetName = val;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagementSelectAssetStatusMenu(
                      selectedAssetStatus: (value) {
                        _assetStatusController.text = value;
                        setState(() {
                          _assetStatus = value;
                        });
                      },
                    ),
                    dialogTitle: 'Select Asset Status',
                    dialogTextController: _assetStatusController,
                    inputTitle: "Asset Status",
                    inputValue: (input) => _assetStatus,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagementSelectFlagsMenu(
                      selectedFlag: (value) {
                        _assetFlagController.text = value;
                        setState(() {
                          _assetFlag = value;
                        });
                      },
                    ),
                    dialogTitle: 'Select Asset Flags',
                    dialogTextController: _assetFlagController,
                    inputTitle: "Asset Flag",
                    inputValue: (input) => _assetFlag,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FarmManagerInputDropdownWidget(
              dialogWidget: FarmManagerDateDialogWidget(
                selectedDate: (value) {
                  _assetPurchaseDateController.text = "${value.year} / ${value.month} / ${value.day}";
                  purchaseDate = value;
                },
              ),
              dialogTitle: 'Select Asset Purchase Date',
              dialogTextController: _assetPurchaseDateController,
              inputTitle: "Purchase Date",
              inputValue: (input) => _purchaseDate,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _assetQuantityController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    style: Styles.inputStyle(),
                    decoration: InputDecoration(
                      label: const Text("Asset Quantity / Size"),
                      errorBorder: Styles.errorBorder(),
                      focusedBorder: Styles.focusBorder(),
                      border: Styles.border(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp("[.]")),
                    ],
                    validator: (arg) {
                      if (isEmpty(arg)) {
                        return 'Asset Quantity cannot be empty';
                      } else if (_assetType == AssetTypes.HUMAN && (int.parse(arg!) > 1)) {
                        return 'You cannot onboard More than on person at once';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      _assetQuantity = val;
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _assetCostController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: Styles.inputStyle(),
                    decoration: InputDecoration(
                      label: const Text("(₦) Asset Cost / Charge"),
                      errorBorder: Styles.errorBorder(),
                      focusedBorder: Styles.focusBorder(),
                      border: Styles.border(),
                    ),
                    validator: (arg) {
                      if (isEmpty(arg)) {
                        return 'Asset Cost cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      _assetCost = val;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FarmManagerInputDropdownWidget(
              dialogWidget: FarmManagementSelectAssetTypeMenu(
                selectedAssetType: (value) {
                  _assetTypeController.text = value;
                  setState(() {
                    _assetType = value;
                  });
                },
              ),
              dialogTitle: 'Select Asset Type',
              dialogTextController: _assetTypeController,
              inputTitle: "Asset Type",
              inputValue: (input) => _assetType,
            ),
            const SizedBox(
              height: 10,
            ),
            if (_assetType == AssetTypes.EQUIPMENT || _assetType == AssetTypes.SENSOR)
              equipmentSensorsUI()
            else
              (_assetType == AssetTypes.SEEDS || _assetType == AssetTypes.PLANTS)
                  ? seedsPlantsUI()
                  : (_assetType == AssetTypes.CHEMICALS)
                      ? chemicalsUI()
                      : (_assetType == AssetTypes.BUILDING)
                          ? buildingsUI()
                          : Container(),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              controller: _assetNotesController,
              style: Styles.inputStyle(),
              decoration: InputDecoration(
                label: const Text("Acquisition Reason"),
                errorBorder: Styles.errorBorder(),
                focusedBorder: Styles.focusBorder(),
                border: Styles.border(),
              ),
              validator: (arg) {
                if (isEmpty(arg)) {
                  return 'Asset Reason cannot be empty';
                } else {
                  return null;
                }
              },
              onSaved: (val) {
                _assetNotes = val;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SquareButton(
              backgroundColor: AppColors.shopOrange,
              press: () {
                if (_validateInputs()) {
                  createNewAsset();
                }
              },
              textColor: AppColors.whiteColor,
              text: 'Next',
            ),
          ],
        ),
      ),
    );
  }

  Widget equipmentSensorsUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _assetSerialController,
                textCapitalization: TextCapitalization.characters,
                style: Styles.inputStyle(),
                decoration: InputDecoration(
                  label: const Text("Serial Number"),
                  errorBorder: Styles.errorBorder(),
                  focusedBorder: Styles.focusBorder(),
                  border: Styles.border(),
                ),
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return 'SerialNumber cannot be empty';
                  } else {
                    return null;
                  }
                },
                onSaved: (val) {
                  _assetSerial = val;
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                style: Styles.inputStyle(),
                decoration: InputDecoration(
                  label: const Text("Supplier / Manufacturer"),
                  errorBorder: Styles.errorBorder(),
                  focusedBorder: Styles.focusBorder(),
                  border: Styles.border(),
                ),
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return 'Supplier / Manufacturer cannot be empty';
                  } else {
                    return null;
                  }
                },
                onSaved: (val) {
                  _assetManufacturer = val;
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          style: Styles.inputStyle(),
          controller: _assetModelController,
          decoration: InputDecoration(
            label: const Text("Model"),
            errorBorder: Styles.errorBorder(),
            focusedBorder: Styles.focusBorder(),
            border: Styles.border(),
          ),
          validator: (arg) {
            if (isEmpty(arg)) {
              return 'Model cannot be empty';
            } else {
              return null;
            }
          },
          onSaved: (val) {
            _assetModel = val;
          },
        ),
      ],
    );
  }

  Widget seedsPlantsUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                style: Styles.inputStyle(),
                controller: _assetCropFamilyController,
                decoration: InputDecoration(
                  label: const Text("Crop Type"),
                  errorBorder: Styles.errorBorder(),
                  focusedBorder: Styles.focusBorder(),
                  border: Styles.border(),
                ),
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return 'Crop Type cannot be empty';
                  } else {
                    return null;
                  }
                },
                onSaved: (val) {
                  _cropFamily = val;
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(),
                style: Styles.inputStyle(),
                controller: _assetTransplantAfterController,
                decoration: InputDecoration(
                  label: const Text("Transplant After (Days)"),
                  errorBorder: Styles.errorBorder(),
                  focusedBorder: Styles.focusBorder(),
                  border: Styles.border(),
                ),
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return 'Transplant After cannot be empty';
                  } else {
                    return null;
                  }
                },
                onSaved: (val) {
                  _transplantAfter = val;
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: Styles.inputStyle(),
          decoration: InputDecoration(
            label: const Text("Mature After (Months)"),
            errorBorder: Styles.errorBorder(),
            focusedBorder: Styles.focusBorder(),
            border: Styles.border(),
          ),
          validator: (String? arg) {
            if (isEmpty(arg)) {
              return 'Mature After cannot be empty';
            } else {
              return null;
            }
          },
          onSaved: (val) {
            _matureAfter = val;
          },
        ),
      ],
    );
  }

  Widget chemicalsUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: FarmManagerInputDropdownWidget(
            dialogWidget: FarmManagerDateDialogWidget(
              selectedDate: (value) {
                _assetManufactureDateController.text = "${value.year} - ${value.month} - ${value.day}";
                manufactureDate = value;
              },
            ),
            dialogTitle: 'Select Manufacture Date',
            dialogTextController: _assetManufactureDateController,
            inputTitle: "Manufacture Date",
            inputValue: (input) => _manufactureDate,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: FarmManagerInputDropdownWidget(
            dialogWidget: FarmManagerDateDialogWidget(
              selectedDate: (value) {
                _assetExpiryDateController.text = "${value.year} - ${value.month} - ${value.day}";
                expiryDate = value;
              },
            ),
            dialogTitle: 'Select Expiry Date',
            dialogTextController: _assetExpiryDateController,
            inputTitle: "Expiry Date",
            inputValue: (input) => _expiryDate,
          ),
        ),
      ],
    );
  }

  Widget buildingsUI() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: Styles.inputStyle(),
      controller: _assetBuildingTypeController,
      decoration: InputDecoration(
        label: const Text("Building Type"),
        errorBorder: Styles.errorBorder(),
        focusedBorder: Styles.focusBorder(),
        border: Styles.border(),
      ),
      validator: (arg) {
        if (isEmpty(arg)) {
          return 'Building Type cannot be empty';
        } else {
          return null;
        }
      },
      onSaved: (val) {
        _buildingType = val;
      },
    );
  }

  bool _validateInputs() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      setState(() {});
      return false;
    }
  }

  Future<void> createNewAsset() async {
    debugPrint(
      "Asset Form: $_assetName $_assetType $_assetFlag $_assetStatus $purchaseDate $manufactureDate $expiryDate $_assetQuantity $_assetSerial $_assetManufacturer $_assetCost $_assetModel $_cropFamily $_transplantAfter $_matureAfter $_buildingType $_assetNotes",
    );
    OrganizationAssetDetailsResponse? data;

    if (widget.addAssetPageArgs.isNewInput) {
      data = await createAsset(
        CreateAssetRequest(
          acquisitionDate: purchaseDate ?? DateTime.now(),
          cost: (_assetCost != null) ? double.parse(_assetCost!.replaceAll(',', '').trim()) : 0,
          createdBy: USER_ID,
          createdDate: DateTime.now(),
          cropFamily: _cropFamily ?? "",
          daysToMaturity: (_matureAfter != null) ? int.parse(_matureAfter!) : 0,
          daysToTransplant: (_transplantAfter != null) ? int.parse(_transplantAfter!) : 0,
          expiryDate: expiryDate ?? DateTime.now(),
          flags: _assetFlag ?? "",
          manufactureDate: manufactureDate ?? DateTime.now(),
          manufacturer: _assetManufacturer ?? "",
          model: _assetModel ?? "",
          name: _assetName ?? "",
          quantity: (_assetCost != null) ? int.parse(_assetQuantity!.replaceAll(',', '').trim()) : 0,
          serialnumber: _assetSerial ?? "",
          status: _assetStatus ?? "",
          structureType: _buildingType ?? "",
          type: _assetType ?? "",
          notes: _assetNotes ?? "",
          modifiedDate: DateTime.now(),
          organizationId: widget.addAssetPageArgs.details!.farmArgs.organizationId,
        ),
      );
    } else {
      data = await updateAsset(
        widget.addAssetPageArgs.details!.asset!.id ?? 0,
        CreateAssetRequest(
          acquisitionDate: purchaseDate ?? DateTime.now(),
          cost: (_assetCost != null) ? double.parse(_assetCost!.replaceAll(',', '').trim()) : 0,
          createdBy: USER_ID,
          createdDate: DateTime.now(),
          cropFamily: _cropFamily ?? "",
          daysToMaturity: (_matureAfter != null) ? int.parse(_matureAfter!) : 0,
          daysToTransplant: (_transplantAfter != null) ? int.parse(_transplantAfter!) : 0,
          expiryDate: expiryDate ?? DateTime.now(),
          flags: _assetFlag ?? "",
          manufactureDate: manufactureDate ?? DateTime.now(),
          manufacturer: _assetManufacturer ?? "",
          model: _assetModel ?? "",
          name: _assetName ?? "",
          quantity: (_assetCost != null) ? int.parse(_assetQuantity!.replaceAll(',', '').trim()) : 0,
          serialnumber: _assetSerial ?? "",
          status: _assetStatus ?? "",
          structureType: _buildingType ?? "",
          type: _assetType ?? "",
          notes: _assetNotes ?? "",
          modifiedDate: DateTime.now(),
          organizationId: widget.addAssetPageArgs.details!.farmArgs.organizationId,
        ),
      );
    }

    _pandora.reRouteUserPopCurrent(
      context,
      "/farmManagerFileUploadPage",
      FileUploadDetailsArgs(
        data,
        null,
        true,
      ),
    );
    debugPrint("ready for upload");
  }
}
