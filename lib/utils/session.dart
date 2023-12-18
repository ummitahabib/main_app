// ignore_for_file: non_constant_identifier_names

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smat_crow/network/crow/models/user_response.dart';

import '../network/crow/models/farm_management/assets/generic_asset_details.dart';
import '../network/crow/models/farm_management/assets/generic_log_response.dart';
import '../network/crow/models/farm_management/assets/generic_organization_assets.dart';

class Session {
  static String FirebaseId = '';
  static String FirebaseDeviceToken = '';
  static String SessionToken = '';
  static UserDetailsResponse? userDetailsResponse;
  static Position? position;
  static String APP_TYPE = "DEV"; //PROD:DEV
  static String userName = '';
  static String userEmail = '';
}

class UnsafeIds {
  static int assetId = 0;
}

class CreateSiteSectorArgs {
  final String organizationId;
  final String siteId;

  final bool isSite;

  CreateSiteSectorArgs(this.organizationId, this.siteId, this.isSite);
}

class CreateSoilSamplesArgs {
  final String missionId;

  final String siteId;

  final bool fromMission;

  final String agentId;

  CreateSoilSamplesArgs(
    this.fromMission,
    this.siteId,
    this.missionId,
    this.agentId,
  );

  Map<String, dynamic> toJson() => {
        "fromMission": fromMission,
        "siteId": siteId,
        "agentId": agentId,
        "missionId": siteId,
      };
}

class FieldAgentOrganizationArgs {
  final String organizationId;

  final String organizationName;

  FieldAgentOrganizationArgs(this.organizationId, this.organizationName);
}

class FarmManagerSiteManagementArgs {
  final LatLng coordinates;
  final String siteName;
  final Set<Polygon> polygon;
  final String organizationId;
  final String siteId;

  FarmManagerSiteManagementArgs(
    this.coordinates,
    this.siteName,
    this.polygon,
    this.organizationId,
    this.siteId,
  );
}

class FarmManagementAssetArgs {
  final Datum? asset;
  final FarmManagerSiteManagementArgs farmArgs;

  FarmManagementAssetArgs(this.asset, this.farmArgs);
}

class FarmManagementTypeManagementArgs {
  final FarmManagerSiteManagementArgs? farmManagerSiteManagementArgs;
  final String? type;

  FarmManagementTypeManagementArgs(
    this.farmManagerSiteManagementArgs,
    this.type,
  );
}

class AddLogAssetPageArgs {
  final bool isNewInput;
  final FarmManagementAssetArgs? details;
  final Completed? logDetails;

  AddLogAssetPageArgs(this.isNewInput, this.details, this.logDetails);
}

class FarmManagementLogDetailsArgs {
  final FarmManagementTypeManagementArgs farmManagerSiteManagementArgs;
  final String type;

  FarmManagementLogDetailsArgs(this.farmManagerSiteManagementArgs, this.type);
}

class FileUploadDetailsArgs {
  final OrganizationAssetDetailsResponse? assetDetailsResponse;
  final Completed? logDetailsResponse;
  final bool? isAsset;

  FileUploadDetailsArgs(
    this.assetDetailsResponse,
    this.logDetailsResponse,
    this.isAsset,
  );
}

class LoginRouterArgs {
  final bool autoLogin;
  final bool canReroute;
  final String reroutePage;
  final String rerouteId;

  LoginRouterArgs(
    this.autoLogin,
    this.canReroute,
    this.reroutePage,
    this.rerouteId,
  );
}
