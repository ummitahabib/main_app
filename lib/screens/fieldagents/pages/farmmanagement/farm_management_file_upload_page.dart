import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../network/crow/models/request/farm_management/generic_publish.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/header_text.dart';
import '../../../widgets/sub_header_text.dart';
import 'farm_management_files_list_page.dart';
import 'farm_management_images_list_page.dart';
import 'fileupload/upload_resource_picture.dart';

class FarmManagementFileUploadWidget extends StatefulWidget {
  final FileUploadDetailsArgs uploadArgs;

  const FarmManagementFileUploadWidget({Key? key, required this.uploadArgs}) : super(key: key);

  @override
  _FarmManagementFileUploadWidgetState createState() {
    return _FarmManagementFileUploadWidgetState();
  }
}

class _FarmManagementFileUploadWidgetState extends State<FarmManagementFileUploadWidget> {
  List<Widget> uploadedImages = [];
  // AssetsResourcesResponse assetFiles;
  // AssetsResourcesResponse assetImages;

  @override
  void initState() {
    super.initState();
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
        actions: [
          TextButton(
            onPressed: () {
              (widget.uploadArgs.isAsset ?? false) ? publishNewAsset() : publishNewLog();
            },
            child: Text(
              "Publish ${(widget.uploadArgs.isAsset ?? false) ? "Asset" : "Log"}",
              style: Styles.regularOrangeBold(),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.farmManagerBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeaderText(
                          text: 'Upload ${(widget.uploadArgs.isAsset ?? false) ? "Asset Archives" : "Log Archives"}',
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          EvaIcons.attach2Outline,
                          size: 20,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const SubHeaderText(
                      text: 'Upload all related Media and Files to showing proof acquisition, delivery and completion',
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Card(
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: AppColors.offWhite,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const HeaderText(
                              text: 'Upload Images',
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const SubHeaderText(text: 'We accept Only: .jpg and .png Images', color: Colors.black),
                            const SizedBox(
                              height: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                (widget.uploadArgs.isAsset ?? false)
                                    ? Provider.of<UploadResourcePicture>(context, listen: false)
                                        .selectResourceImageType(
                                        widget.uploadArgs.assetDetailsResponse!.data.id!,
                                        -1,
                                        widget.uploadArgs.isAsset!,
                                        true,
                                      )
                                    : Provider.of<UploadResourcePicture>(context, listen: false)
                                        .selectResourceImageType(
                                        -1,
                                        widget.uploadArgs.logDetailsResponse!.id!,
                                        widget.uploadArgs.isAsset!,
                                        true,
                                      );
                              },
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: AppColors.dashBgColorBlack.withOpacity(0.08),
                                  border: Border.all(color: AppColors.greyTextLogin),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      EvaIcons.imageOutline,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("Choose images here ...", style: Styles.regularBold18()),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SubHeaderText(text: '(Max file size: 10Mb)', color: AppColors.greyTextLogin),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            if (widget.uploadArgs.isAsset ?? false)
                              FarmManagementAssetImagesPage(
                                assetId: widget.uploadArgs.assetDetailsResponse!.data.id!,
                                isAsset: true,
                              )
                            else
                              FarmManagementAssetImagesPage(
                                assetId: widget.uploadArgs.logDetailsResponse!.id!,
                                isAsset: false,
                              )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Card(
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: AppColors.offWhite,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const HeaderText(
                              text: 'Upload Files',
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const SubHeaderText(text: 'We accept Only: .jpg and .png Files', color: Colors.black),
                            const SizedBox(
                              height: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                (widget.uploadArgs.isAsset ?? false)
                                    ? Provider.of<UploadResourcePicture>(context, listen: false)
                                        .selectResourceImageType(
                                        widget.uploadArgs.assetDetailsResponse!.data.id!,
                                        0,
                                        widget.uploadArgs.isAsset ?? false,
                                        false,
                                      )
                                    : Provider.of<UploadResourcePicture>(context, listen: false)
                                        .selectResourceImageType(
                                        0,
                                        widget.uploadArgs.logDetailsResponse!.id!,
                                        widget.uploadArgs.isAsset ?? false,
                                        false,
                                      );
                              },
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: AppColors.dashBgColorBlack.withOpacity(0.08),
                                  border: Border.all(color: AppColors.greyTextLogin),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Styles.fileOutlineDefault(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("Choose Files here ...", style: Styles.regularBold18()),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SubHeaderText(text: '(Max file size: 10Mb)', color: AppColors.greyTextLogin),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            if (widget.uploadArgs.isAsset ?? false)
                              FarmManagementAssetFilesPage(
                                assetId: widget.uploadArgs.assetDetailsResponse!.data.id!,
                                isAsset: true,
                              )
                            else
                              FarmManagementAssetFilesPage(
                                assetId: widget.uploadArgs.logDetailsResponse!.id!,
                                isAsset: false,
                              ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future publishNewAsset() async {
    final publish = await publishAsset(PublishAsset(activityId: widget.uploadArgs.assetDetailsResponse!.data.id!));
/*    _pandora.reRouteUser(context, '/farmManagerOrganizationDetails',
        FieldAgentOrganizationArgs(organizationId, organizationName));*/
    return publish;
  }

  Future publishNewLog() async {
    final publish = await publishLog(PublishAsset(activityId: widget.uploadArgs.logDetailsResponse!.id!));
    // _pandora.reRouteUser(context, '/farmManagerOrganizationDetails',
    //     FieldAgentOrganizationArgs(organizationId, organizationName));
    return publish;
  }
}
