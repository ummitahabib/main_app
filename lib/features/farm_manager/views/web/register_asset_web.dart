import 'package:beamer/beamer.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/farm_manager/views/web/upload_archives_web.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/chemical_ui.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/colored_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/equipment_sensor_ui.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/plant_seed_ui.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/select_container.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/data/model/add_asset_request.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_drop_down.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

enum AssetTypeEnum { chemicals, equipment, sensor, plant, seed, building, human }

class RegisterAssetWeb extends StatefulHookConsumerWidget {
  const RegisterAssetWeb({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterAssetState();
}

class _RegisterAssetState extends ConsumerState<RegisterAssetWeb> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final assetName = useTextEditingController();
    final assetStatus = useState<String?>(null);
    final assetCurrency = useState<String?>(null);
    final assetFlag = useState<String?>(null);
    final purchaseDate = useState<String?>(null);
    final assetType = useState<String?>(null);
    final assetSize = useTextEditingController();
    final assetCost = useTextEditingController();
    final reasonForAcq = useTextEditingController();
    final assetModel = useTextEditingController();
    final assetCropFamily = useTextEditingController();
    final assetbuilding = useTextEditingController();
    final assetMaturityDays = useTextEditingController();
    final assetTransplantDays = useTextEditingController();
    final assetManufacturer = useTextEditingController();
    final assetSerialNumber = useTextEditingController();
    final assetLifeSpan = useState<Map<String, TextEditingController>>(
      {"start": useTextEditingController(), "end": useTextEditingController()},
    );
    final asset = ref.watch(assetProvider);
    final shared = ref.watch(sharedProvider);
    final path = (context.currentBeamLocation.state as BeamState).uri.queryParameters;
    useEffect(
      () {
        Future(() {
          if (path["assetId"] != null && path["assetId"]!.isNotEmpty) {
            asset.getAssetDetails(path["assetId"]!);
          }
          if (shared.assetStatusList.isEmpty) {
            shared.getAssetStatus();
          }
          if (shared.flagList.isEmpty) {
            shared.getFlags();
          }

          if (shared.assetTypesList.isEmpty) {
            shared.getAssetTypes();
          }

          if (shared.currencyList.isEmpty) {
            shared.getCurrencies();
          }
        });
        if (asset.assetDetails != null) {
          assetName.text = asset.assetDetails!.assets!.name ?? emptyString;
          assetSize.text = (asset.assetDetails!.assets!.quantity ?? 0).toString();
          assetCost.text = (asset.assetDetails!.assets!.cost ?? 0).toString().replaceAll(".", "");
          reasonForAcq.text = asset.assetDetails!.assets!.notes ?? "";
          assetModel.text = asset.assetDetails!.assets!.model ?? "";
          assetCropFamily.text = asset.assetDetails!.assets!.cropFamily ?? "";
          assetbuilding.text = asset.assetDetails!.assets!.structureType ?? "";
          assetMaturityDays.text = (asset.assetDetails!.assets!.daysToMaturity ?? "").toString();
          assetTransplantDays.text = (asset.assetDetails!.assets!.daysToTransplant ?? "").toString();
          assetManufacturer.text = (asset.assetDetails!.assets!.manufacturer ?? "").toString();
          assetSerialNumber.text = (asset.assetDetails!.assets!.serialnumber ?? "").toString();
          assetLifeSpan.value['start']!.text = DateFormat("yyyy-MM-dd").format(
            asset.assetDetails!.assets!.manufactureDate ?? DateTime.now(),
          );
          assetLifeSpan.value['end']!.text =
              DateFormat("yyyy-MM-dd").format(asset.assetDetails!.assets!.expiryDate ?? DateTime.now());
          assetStatus.value = asset.assetDetails!.assets!.status ?? emptyString;
          assetCurrency.value = asset.assetDetails!.assets!.currency ?? emptyString;
          assetType.value = asset.assetDetails!.assets!.type ?? emptyString;
          purchaseDate.value = DateFormat("yyyy-MM-dd").format(
            asset.assetDetails!.assets!.acquisitionDate ?? DateTime.now(),
          );
          assetFlag.value = (asset.assetDetails!.assets!.assetFlags!.isNotEmpty && shared.flagList.isNotEmpty)
              ? shared.flagList
                      .firstWhere(
                        (element) => element.uuid == asset.assetDetails!.assets!.assetFlags!.first,
                        orElse: () => shared.flagList.first,
                      )
                      .flag ??
                  ""
              : null;
        }
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(context),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(SpacingConstants.double20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldHeaderText(
                      text: (asset.assetDetails != null) ? updateAssetText : registerAssetText,
                      fontSize: SpacingConstants.font24,
                    ),
                    const Ymargin(SpacingConstants.double20),
                    Text(
                      (asset.assetDetails != null) ? updateAssetLabelText : registerAssetLabelText,
                      style: Styles.smatCrowParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue400,
                      ),
                    ),
                    const Ymargin(SpacingConstants.size30),
                    CustomTextField(
                      controller: assetName,
                      hintText: assetNameText,
                      textCapitalization: TextCapitalization.characters,
                      validator: (arg) {
                        if (isEmpty(arg)) {
                          return '$assetNameText $cannotBeEmpty';
                        } else {
                          return null;
                        }
                      },
                      text: assetNameText,
                      keyboardType: TextInputType.text,
                    ),
                    const Ymargin(SpacingConstants.size20),
                    SelectContainer(
                      title: assetStatusText,
                      hintText: selectYourOption,
                      function: () {
                        customDialogAndModal(
                          context,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DialogHeader(
                                headText: "$selectText $assetStatusText",
                                callback: () {
                                  OneContext().popDialog();
                                },
                                showIcon: true,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              ...shared.assetStatusList
                                  .map(
                                    (e) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Xmargin(SpacingConstants.font10),
                                        Radio(
                                          value: assetStatus.value == e.status,
                                          groupValue: true,
                                          onChanged: (value) {
                                            assetStatus.value = e.status;
                                            OneContext().popDialog();
                                          },
                                        ),
                                        InkWell(
                                          onTap: () {
                                            assetStatus.value = e.status;
                                            OneContext().popDialog();
                                          },
                                          child: ColoredContainer(
                                            color: dummyAssetStatusList
                                                .firstWhere(
                                                  (element) => element.name.toLowerCase().contains(
                                                        (e.status ?? emptyString).toLowerCase(),
                                                      ),
                                                  orElse: () => dummyAssetStatusList.first,
                                                )
                                                .color,
                                            text: e.status ?? emptyString,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                              const Ymargin(SpacingConstants.double20)
                            ],
                          ),
                        );
                      },
                      value: assetStatus.value,
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                    const Ymargin(SpacingConstants.size20),
                    CustomDropdownField(
                      labelText: currencyText,
                      items: shared.currencyList.map((e) => e.name).toList(),
                      value: assetCurrency.value,
                      hintText: selectYourOption,
                      onChanged: (value) {
                        assetCurrency.value = value;
                      },
                    ),
                    const Ymargin(SpacingConstants.size20),
                    SelectContainer(
                      title: assetFlagText,
                      hintText: selectYourOption,
                      function: () {
                        customDialogAndModal(
                          context,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DialogHeader(
                                headText: "$selectText $assetFlagText",
                                callback: () {
                                  OneContext().popDialog();
                                },
                                showIcon: true,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                              ...shared.flagList
                                  .map(
                                    (e) => RadioListTile(
                                      value: assetFlag.value == e.flag,
                                      groupValue: true,
                                      dense: true,
                                      title: Text(
                                        e.flag ?? "",
                                        style: Styles.smatCrowSubParagraphRegular(
                                          color: AppColors.SmatCrowNeuBlue900,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        assetFlag.value = e.flag;

                                        OneContext().popDialog();
                                      },
                                    ),
                                  )
                                  .toList()
                            ],
                          ),
                        );
                      },
                      value: assetFlag.value,
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                    const Ymargin(SpacingConstants.size20),
                    SelectContainer(
                      value: purchaseDate.value,
                      title: purchaseDateText,
                      hintText: selectDateText,
                      function: () async {
                        if (FocusScope.of(context).hasFocus) {
                          FocusScope.of(context).unfocus();
                        }
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2100),
                          currentDate: DateTime.now(),
                        );
                        if (date != null) {
                          purchaseDate.value = DateFormat("yyyy-MM-dd").format(date);
                        }
                      },
                    ),
                    const Ymargin(SpacingConstants.size20),
                    SelectContainer(
                      title: assetTypeText,
                      hintText: selectYourOption,
                      function: () {
                        customDialogAndModal(
                          context,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DialogHeader(
                                headText: "$selectText $assetTypeText",
                                callback: () {
                                  OneContext().popDialog();
                                },
                                showDivider: false,
                                showIcon: true,
                              ),
                              const Divider(),
                              ...shared.assetTypesList
                                  .map(
                                    (e) => RadioListTile(
                                      value: assetType.value == e.types,
                                      groupValue: true,
                                      dense: true,
                                      title: Text(
                                        e.types ?? emptyString,
                                        style: Styles.smatCrowSubParagraphRegular(
                                          color: AppColors.SmatCrowNeuBlue900,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        assetType.value = e.types;

                                        OneContext().popDialog();
                                      },
                                    ),
                                  )
                                  .toList()
                            ],
                          ),
                        );
                      },
                      value: assetType.value,
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                    const Ymargin(SpacingConstants.size20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: assetSize,
                            hintText: enterQuantityText,
                            validator: (arg) {
                              if (isEmpty(arg)) {
                                return '$quantityText $cannotBeEmpty';
                              } else if (assetType.value!.toLowerCase() == AssetTypeEnum.human.name &&
                                  (int.parse(arg!) > 1)) {
                                return assetQuantityWarningText;
                              } else {
                                return null;
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp("[.]")),
                            ],
                            text: quantityText,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const Xmargin(SpacingConstants.size10),
                        Expanded(
                          child: CustomTextField(
                            controller: assetCost,
                            hintText: enterCostText,
                            validator: (arg) {
                              if (isEmpty(arg)) {
                                return '$costText $cannotBeEmpty';
                              } else {
                                return null;
                              }
                            },
                            text: costText,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyTextInputFormatter(name: ""),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        )
                      ],
                    ),
                    const Ymargin(SpacingConstants.size20),
                    Builder(
                      builder: (context) {
                        if (assetType.value == null) {
                          return const SizedBox.shrink();
                        }
                        if (assetType.value!.toLowerCase() == AssetTypeEnum.equipment.name ||
                            assetType.value!.toLowerCase() == AssetTypeEnum.sensor.name) {
                          return EquipmentSensorUI(
                            assetSerialNumber: assetSerialNumber,
                            assetManufacturer: assetManufacturer,
                            assetModel: assetModel,
                          );
                        }
                        if (assetType.value!.toLowerCase() == AssetTypeEnum.seed.name ||
                            assetType.value!.toLowerCase() == AssetTypeEnum.plant.name) {
                          return PlantSeedUI(
                            assetCropFamily: assetCropFamily,
                            assetTransplantDays: assetTransplantDays,
                            assetMaturityDays: assetMaturityDays,
                          );
                        }
                        if (assetType.value!.toLowerCase() == AssetTypeEnum.chemicals.name) {
                          return ChemicalUI(assetLifeSpan: assetLifeSpan);
                        }
                        if (assetType.value!.toLowerCase() == AssetTypeEnum.building.name) {
                          return CustomTextField(
                            hintText: buildingTypeText,
                            keyboardType: TextInputType.text,
                            controller: assetbuilding,
                            textCapitalization: TextCapitalization.characters,
                            text: buildingTypeText,
                            validator: (arg) {
                              if (isEmpty(arg)) {
                                return '$buildingTypeText $cannotBeEmpty';
                              } else {
                                return null;
                              }
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                    const Ymargin(SpacingConstants.size20),
                    CustomTextField(
                      controller: reasonForAcq,
                      hintText: reasonForAcqText,
                      text: reasonText,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      validator: (arg) {
                        if (isEmpty(arg)) {
                          return '$reasonText $cannotBeEmpty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const Ymargin(SpacingConstants.size30),
                    CustomButton(
                      text: continueText,
                      loading: asset.loading,
                      onPressed: () async {
                        if (FocusScope.of(context).hasFocus) {
                          FocusScope.of(context).unfocus();
                        }

                        if (assetStatus.value == null ||
                            assetFlag.value == null ||
                            assetType.value == null ||
                            purchaseDate.value == null ||
                            assetCurrency.value == null) {
                          snackBarMsg(validationWarningText);
                          return;
                        }
                        if (assetType.value!.toLowerCase() == AssetTypeEnum.chemicals.name &&
                            (assetLifeSpan.value['start']!.text.isEmpty || assetLifeSpan.value['end']!.text.isEmpty)) {
                          snackBarMsg(dateWarningText);
                          return;
                        }
                        if (formKey.currentState!.validate()) {
                          if (ref.read(sharedProvider).userInfo == null) return;

                          final req = AddAssetRequest(
                            createdBy: shared.userInfo!.user.id,
                            deleted: "N",
                            createdDate: DateTime.now().toUtc(),
                            modifiedDate: DateTime.now().toUtc(),
                            organizationId: await ref.read(sharedProvider).getOrganizationId(),
                            name: assetName.text,
                            status: assetStatus.value ?? "",
                            flags: assetFlag.value!,
                            assetFlags: [
                              shared.flagList
                                      .firstWhere(
                                        (element) => element.flag == assetFlag.value,
                                      )
                                      .uuid ??
                                  emptyString
                            ],
                            type: assetType.value!,
                            notes: reasonForAcq.text,
                            manufactureDate: assetLifeSpan.value['start']!.text.isEmpty
                                ? null
                                : DateTime.parse(
                                    assetLifeSpan.value['start']!.text,
                                  ).toUtc(),
                            expiryDate: assetLifeSpan.value['end']!.text.isEmpty
                                ? null
                                : DateTime.parse(
                                    assetLifeSpan.value['end']!.text,
                                  ).toUtc(),
                            cost: int.parse(
                              assetCost.text.replaceAll(",", "").replaceAll(".", ""),
                            ),
                            currency: assetCurrency.value,
                            quantity: int.parse(assetSize.text.replaceAll(",", "")),
                            acquisitionDate: DateTime.parse(purchaseDate.value!),
                            cropFamily: assetCropFamily.text.isEmpty ? null : assetCropFamily.text,
                            daysToMaturity: assetMaturityDays.text.isEmpty ? null : int.parse(assetMaturityDays.text),
                            daysToTransplant:
                                assetTransplantDays.text.isEmpty ? null : int.parse(assetTransplantDays.text),
                            manufacturer: assetManufacturer.text.isEmpty ? null : assetManufacturer.text,
                            model: assetModel.text.isEmpty ? null : assetModel.text,
                            serialnumber: assetSerialNumber.text.isEmpty ? null : assetSerialNumber.text,
                            structureType: assetbuilding.text.isEmpty ? null : assetbuilding.text,
                          );
                          if (asset.assetDetails != null) {
                            await ref.read(assetProvider).updateAsset(req).then((value) {
                              if (value) {
                                customDialog(
                                  context,
                                  const UploadArchivesWeb(title: assetText),
                                );
                              }
                            });
                          } else {
                            await ref.read(assetProvider).addAsset(req).then((value) {
                              if (value) {
                                customDialog(
                                  context,
                                  const UploadArchivesWeb(title: assetText),
                                );
                              }
                            });
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SpacingConstants.font16),
                  image: const DecorationImage(
                    image: AssetImage(AppAssets.logImage),
                  ),
                ),
                margin: const EdgeInsets.only(right: SpacingConstants.double20),
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: SpacingConstants.double20,
                    bottom: SpacingConstants.size70,
                    right: SpacingConstants.double20,
                  ),
                  child: Text(
                    expandHorizon,
                    maxLines: 3,
                    style: Styles.smatCrowHeadingBold3(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AssetStatus {
  final Color color;
  final String name;

  AssetStatus(this.color, this.name);
}

final dummyAssetStatusList = [
  AssetStatus(AppColors.SmatCrowGreen500, "Active"),
  AssetStatus(AppColors.SmatCrowPrimary500, "Not Commissioned"),
  AssetStatus(AppColors.SmatCrowAccentPurple, "Damaged"),
  AssetStatus(AppColors.SmatCrowAccentBlue, "In Repairs"),
  AssetStatus(AppColors.SmatCrowNeuBlue900, "Archived"),
  AssetStatus(AppColors.SmatCrowGreen500, completedText),
  AssetStatus(AppColors.SmatCrowPrimary500, ongoingText),
  AssetStatus(AppColors.SmatCrowAccentPurple, upcomingText),
  AssetStatus(AppColors.SmatCrowAccentBlue, missedText),
  AssetStatus(AppColors.SmatCrowBlue900, ""),
];
