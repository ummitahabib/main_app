import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/farm_management/config/generic_flag_response.dart';
import 'package:smat_crow/network/crow/models/farm_management/config/generic_quantity_response.dart';
import 'package:smat_crow/network/crow/models/farm_management/config/generic_season_response.dart';
import 'package:smat_crow/network/crow/models/farm_management/config/generic_status_response.dart';
import 'package:smat_crow/network/crow/models/farm_management/logs/generic_additional_log_details.dart';
import 'package:smat_crow/network/crow/models/request/farm_management/upload_asset_resource.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/session.dart';

import '../../utils/constants.dart';
import 'models/farm_management/agent/generic_field_agent_organizations.dart';
import 'models/farm_management/agent/generic_field_agent_statistics.dart';
import 'models/farm_management/assets/generic_asset_details.dart';
import 'models/farm_management/assets/generic_asset_resources.dart';
import 'models/farm_management/assets/generic_log_response.dart';
import 'models/farm_management/assets/generic_organization_assets.dart';
import 'models/farm_management/assets/generic_post_response.dart';
import 'models/farm_management/config/generic_type_response.dart';
import 'models/farm_management/logs/generic_log_details.dart';
import 'models/request/farm_management/create_asset.dart';
import 'models/request/farm_management/create_log.dart';
import 'models/request/farm_management/create_log_asset.dart';
import 'models/request/farm_management/create_log_owner.dart';
import 'models/request/farm_management/create_log_remark.dart';
import 'models/request/farm_management/generic_publish.dart';

Pandora _pandora = Pandora();

///Configurations
///
Future<GenericStatusResponse?> getAssetStatus() async {
  debugPrint('getting asset status');
  GenericStatusResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/system-config/findAllAssetStatus'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'findAllAssetStatus',
      '$BASE_URL/farm-manager/system-config/findAllAssetStatus',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GenericStatusResponse.fromJson(jsonDecode(response.body));
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'findAllAssetStatus',
      '$BASE_URL/farm-manager/system-config/findAllAssetStatus',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'findAllAssetStatus',
      '$BASE_URL/farm-manager/system-config/findAllAssetStatus',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GenericTypeResponse?> getAssetTypes() async {
  debugPrint('getting asset types');
  GenericTypeResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/system-config/findAllAssetTypes'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'findAllAssetTypes',
      '$BASE_URL/farm-manager/system-config/findAllAssetTypes',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GenericTypeResponse.fromJson(jsonDecode(response.body));
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'findAllAssetTypes',
      '$BASE_URL/farm-manager/system-config/findAllAssetTypes',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'findAllAssetTypes',
      '$BASE_URL/farm-manager/system-config/findAllAssetTypes',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GenericFlagResponse?> getLogFlags() async {
  debugPrint('getting flag types');
  GenericFlagResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/system-config/findAllFlags'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'findAllFlags',
      '$BASE_URL/farm-manager/system-config/findAllFlags',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GenericFlagResponse.fromJson(jsonDecode(response.body));
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'findAllFlags',
      '$BASE_URL/farm-manager/system-config/findAllFlags',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'findAllFlags',
      '$BASE_URL/farm-manager/system-config/findAllFlags',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GenericStatusResponse?> getLogStatus() async {
  debugPrint('getting log status');
  GenericStatusResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/system-config/findAllLogStatus'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'findAllLogStatus',
      '$BASE_URL/farm-manager/system-config/findAllLogStatus',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GenericStatusResponse.fromJson(jsonDecode(response.body));
    //   return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'findAllLogStatus',
      '$BASE_URL/farm-manager/system-config/findAllLogStatus',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'findAllLogStatus',
      '$BASE_URL/farm-manager/system-config/findAllLogStatus',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GenericTypeResponse?> getLogTypes() async {
  debugPrint('getting log types');
  GenericTypeResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/system-config/findAllLogTypes'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'findAllLogTypes',
      '$BASE_URL/farm-manager/system-config/findAllLogTypes',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GenericTypeResponse.fromJson(jsonDecode(response.body));
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'findAllLogTypes',
      '$BASE_URL/farm-manager/system-config/findAllLogTypes',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'findAllLogTypes',
      '$BASE_URL/farm-manager/system-config/findAllLogTypes',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GenericSeasonResponse?> getPlantingSeasons() async {
  debugPrint('getting planting seasons');
  GenericSeasonResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/system-config/findAllPlantingSeasons'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'findAllPlantingSeasons',
      '$BASE_URL/farm-manager/system-config/findAllPlantingSeasons',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GenericSeasonResponse.fromJson(jsonDecode(response.body));
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'findAllPlantingSeasons',
      '$BASE_URL/farm-manager/system-config/findAllPlantingSeasons',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'findAllPlantingSeasons',
      '$BASE_URL/farm-manager/system-config/findAllPlantingSeasons',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GenericQuantityResponse?> getMeasurementQuantities() async {
  debugPrint('getting measurement quantities');
  GenericQuantityResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/system-config/findAllQuantities'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'findAllQuantities',
      '$BASE_URL/farm-manager/system-config/findAllQuantities',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GenericQuantityResponse.fromJson(
      jsonDecode(response.body).map((model) => GenericQuantityResponse.fromJson(model)),
    );
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'findAllQuantities',
      '$BASE_URL/farm-manager/system-config/findAllQuantities',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'findAllQuantities',
      '$BASE_URL/farm-manager/system-config/findAllQuantities',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<FieldAgentOrganization?> getFieldAgentOrganizations(
  String fieldAgentId,
) async {
  debugPrint('getting field agent organizations');
  FieldAgentOrganization? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/farm-manager/field-agent-config/findAllOrganizationsForFieldAgentsById/$fieldAgentId',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'findAllOrganizationsForFieldAgentsById',
      '$BASE_URL/farm-manager/field-agent-config/findAllOrganizationsForFieldAgentsById',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = FieldAgentOrganization.fromJson(jsonDecode(response.body));
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'findAllOrganizationsForFieldAgentsById',
      '$BASE_URL/farm-manager/field-agent-config/findAllOrganizationsForFieldAgentsById',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'findAllOrganizationsForFieldAgentsById',
      '$BASE_URL/farm-manager/field-agent-config/findAllOrganizationsForFieldAgentsById',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

///* Organizations Asset Info
///
Future<OrganizationAssetsResponse?> getOrganizationAssets(
  String organizationId,
) async {
  debugPrint('getting assets for organizations');
  OrganizationAssetsResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/farm-manager/assets/findAllByOrganization/$organizationId',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getOrganizationAssets',
      '$BASE_URL/farm-manager/assets/findAllByOrganization/$organizationId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = OrganizationAssetsResponse.fromJson(jsonDecode(response.body));
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getOrganizationAssets',
      '$BASE_URL/farm-manager/assets/findAllByOrganization/$organizationId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getOrganizationAssets',
      '$BASE_URL/farm-manager/assets/findAllByOrganization/$organizationId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<OrganizationAssetsResponse?> getOrganizationAssetsAndType(
  String organizationId,
  String assetType,
) async {
  debugPrint('getting assets for organizations');
  OrganizationAssetsResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/farm-manager/assets/findAllByOrganizationAndType/$organizationId/$assetType',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getOrganizationAssets',
      '$BASE_URL/farm-manager/assets/findAllByOrganizationAndType/$organizationId/$assetType',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = OrganizationAssetsResponse.fromJson(jsonDecode(response.body));
    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getOrganizationAssets',
      '$BASE_URL/farm-manager/assets/findAllByOrganization/$organizationId/$assetType',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getOrganizationAssets',
      '$BASE_URL/farm-manager/assets/findAllByOrganization/$organizationId/$assetType',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<OrganizationAssetDetailsResponse?> getOrganizationAssetDetails(
  int assetId,
) async {
  debugPrint('getting assets details');
  OrganizationAssetDetailsResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/assets/findAssetById/$assetId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getOrganizationAssetDetails',
      '$BASE_URL/farm-manager/assets/findAssetById/$assetId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = OrganizationAssetDetailsResponse.fromJson(jsonDecode(response.body));
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getOrganizationAssetDetails',
      '$BASE_URL/farm-manager/assets/findAssetById/$assetId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getOrganizationAssetDetails',
      '$BASE_URL/farm-manager/assets/findAssetById/$assetId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<AssetsResourcesResponse?> getAssetsMedia(int assetId) async {
  debugPrint('getting assets Media');
  AssetsResourcesResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/assets/findAssetImages/$assetId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getAssetsMedia',
      '$BASE_URL/farm-manager/assets/findAssetImages/$assetId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = AssetsResourcesResponse.fromJson(jsonDecode(response.body));
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getAssetsMedia',
      '$BASE_URL/farm-manager/assets/findAssetImages/$assetId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getAssetsMedia',
      '$BASE_URL/farm-manager/assets/findAssetImages/$assetId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<AssetsResourcesResponse?> getAssetsFiles(int assetId) async {
  debugPrint('getting assets Files');
  AssetsResourcesResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/assets/findAssetFiles/$assetId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    debugPrint('fetched assets Files');
    _pandora.logAPIEvent(
      'getAssetsFiles',
      '$BASE_URL/farm-manager/assets/findAssetFiles/$assetId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = AssetsResourcesResponse.fromJson(jsonDecode(response.body));
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getAssetsFiles',
      '$BASE_URL/farm-manager/assets/findAssetFiles/$assetId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getAssetsFiles',
      '$BASE_URL/farm-manager/assets/findAssetFiles/$assetId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

///* Asset Modification
///
Future<GenericPostResponse> publishAsset(PublishAsset request) async {
  debugPrint('publish asset');
  await OneContext().showProgressIndicator();
  GenericPostResponse result;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/assets/publishAsset'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'publishAsset',
      '$BASE_URL/farm-manager/assets/publishAsset',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Asset Published'),
        backgroundColor: Colors.green,
      ),
    );
    result = GenericPostResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'publishAsset',
      '$BASE_URL/farm-manager/assets/publishAsset',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = GenericPostResponse.fromJson(jsonDecode(response.body));
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else if (response.statusCode == HttpStatus.badRequest) {
    _pandora.logAPIEvent(
      'publishAsset',
      '$BASE_URL/farm-manager/assets/publishAsset',
      'FAILED',
      HttpStatus.badRequest.toString(),
    );
    result = GenericPostResponse.fromJson(jsonDecode(response.body));
    await OneContext().showSnackBar(builder: (_) => SnackBar(content: Text(result.data)));
  } else {
    _pandora.logAPIEvent(
      'publishAsset',
      '$BASE_URL/farm-manager/assets/publishAsset',
      'FAILED',
      response.statusCode.toString(),
    );
    result = GenericPostResponse.fromJson(jsonDecode(response.body));
  }
  OneContext().hideProgressIndicator();
  return result;
}

Future<OrganizationAssetDetailsResponse?> createAsset(
  CreateAssetRequest request,
) async {
  debugPrint('create asset');
  await OneContext().showProgressIndicator();
  OrganizationAssetDetailsResponse? result;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/assets/registerAsset'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request.toJson()),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'createAsset',
      '$BASE_URL/farm-manager/assets/createAsset',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Asset Saved to Draft'),
        backgroundColor: Colors.orange,
      ),
    );
    result = OrganizationAssetDetailsResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'createAsset',
      '$BASE_URL/farm-manager/assets/createAsset',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = null;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    OneContext().hideProgressIndicator();
    _pandora.logAPIEvent(
      'createAsset',
      '$BASE_URL/farm-manager/assets/createAsset',
      'FAILED',
      response.statusCode.toString(),
    );
    result = null;
  }
  OneContext().hideProgressIndicator();
  return result;
}

Future<OrganizationAssetDetailsResponse?> updateAsset(
  int assetId,
  CreateAssetRequest request,
) async {
  debugPrint('update asset');
  await OneContext().showProgressIndicator();
  OrganizationAssetDetailsResponse? result;
  final response = await http.put(
    Uri.parse('$BASE_URL/farm-manager/assets/updateAsset/$assetId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'createAsset',
      '$BASE_URL/farm-manager/assets/createAsset',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Asset Saved to Draft'),
        backgroundColor: Colors.orange,
      ),
    );
    result = OrganizationAssetDetailsResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'createAsset',
      '$BASE_URL/farm-manager/assets/createAsset',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = null;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    OneContext().hideProgressIndicator();
    _pandora.logAPIEvent(
      'createAsset',
      '$BASE_URL/farm-manager/assets/createAsset',
      'FAILED',
      response.statusCode.toString(),
    );
    result = null;
  }
  return result;
}

Future<bool> uploadAssetFile(UploadAssetResource request) async {
  debugPrint('upload asset file');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/assets/uploadAssetFile'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'uploadAssetFile',
      '$BASE_URL/farm-manager/assets/uploadAssetFile',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('File Uploaded'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'uploadAssetFile',
      '$BASE_URL/farm-manager/assets/uploadAssetFile',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'uploadAssetFile',
      '$BASE_URL/farm-manager/assets/uploadAssetFile',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  return result;
}

Future<bool> uploadAssetMedia(UploadAssetResource request) async {
  debugPrint('upload asset media');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/assets/uploadAssetMedia'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'uploadAssetMedia',
      '$BASE_URL/farm-manager/assets/uploadAssetMedia',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Media Uploaded'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'uploadAssetMedia',
      '$BASE_URL/farm-manager/assets/uploadAssetMedia',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'uploadAssetMedia',
      '$BASE_URL/farm-manager/assets/uploadAssetMedia',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  return result;
}

/// Logs
///

Future<bool> publishLog(PublishAsset request) async {
  debugPrint('publish log');
  await OneContext().showProgressIndicator();
  bool result = false;
  GenericPostResponse res;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/logs/publishLog'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'publishLog',
      '$BASE_URL/farm-manager/logs/publishLog',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Log Published'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'publishLog',
      '$BASE_URL/farm-manager/logs/publishLog',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else if (response.statusCode == HttpStatus.badRequest) {
    _pandora.logAPIEvent(
      'publishAsset',
      '$BASE_URL/farm-manager/assets/publishAsset',
      'FAILED',
      HttpStatus.badRequest.toString(),
    );
    res = GenericPostResponse.fromJson(jsonDecode(response.body));
    await OneContext().showSnackBar(builder: (_) => SnackBar(content: Text(res.data)));
  } else {
    _pandora.logAPIEvent(
      'publishLog',
      '$BASE_URL/farm-manager/logs/publishLog',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  return result;
}

Future<GetLogDetails?> createLog(CreateLogRequest request) async {
  debugPrint('create log');
  await OneContext().showProgressIndicator();
  GetLogDetails? result;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/logs/registerLog'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'createLog',
      '$BASE_URL/farm-manager/logs/registerLog',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Log Saved to Draft'),
        backgroundColor: Colors.orange,
      ),
    );
    result = GetLogDetails.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'createLog',
      '$BASE_URL/farm-manager/logs/registerLog',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = null;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'createLog',
      '$BASE_URL/farm-manager/logs/registerLog',
      'FAILED',
      response.statusCode.toString(),
    );
    result = null;
  }
  OneContext().hideProgressIndicator();
  return result;
}

Future<GetLogDetails?> updateLog(int logId, CreateLogRequest request) async {
  debugPrint('update log');
  await OneContext().showProgressIndicator();
  GetLogDetails? result;
  final response = await http.put(
    Uri.parse('$BASE_URL/farm-manager/logs/updateLog/$logId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'updateLog',
      '$BASE_URL/farm-manager/logs/updateLog/$logId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Log Saved to Draft'),
        backgroundColor: Colors.orange,
      ),
    );
    result = GetLogDetails.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'updateLog',
      '$BASE_URL/farm-manager/logs/updateLog/$logId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = null;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'updateLog',
      '$BASE_URL/farm-manager/logs/updateLog/$logId',
      'FAILED',
      response.statusCode.toString(),
    );
    result = null;
  }
  return result;
}

Future<bool> attachLogAsset(CreateLogAsset request) async {
  debugPrint('create log asset');
  await OneContext().showProgressIndicator();
  GenericPostResponse res;

  bool result = false;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/logs/addLogAsset'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'attachLogAsset',
      '$BASE_URL/farm-manager/logs/addLogAsset',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Asset Added to Log'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'attachLogAsset',
      '$BASE_URL/farm-manager/logs/addLogAsset',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else if (response.statusCode == HttpStatus.badRequest) {
    _pandora.logAPIEvent(
      'publishAsset',
      '$BASE_URL/farm-manager/assets/publishAsset',
      'FAILED',
      HttpStatus.badRequest.toString(),
    );
    res = GenericPostResponse.fromJson(jsonDecode(response.body));
    await OneContext().showSnackBar(builder: (_) => SnackBar(content: Text(res.data)));
  } else {
    _pandora.logAPIEvent(
      'attachLogAsset',
      '$BASE_URL/farm-manager/logs/addLogAsset',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  return result;
}

Future<bool> uploadLogMedia(UploadAssetResource request) async {
  debugPrint('upload log media');
  await OneContext().showProgressIndicator();
  bool result = false;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/logs/uploadLogMedia'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'uploadLogMedia',
      '$BASE_URL/farm-manager/logs/uploadLogMedia',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Media Uploaded'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'uploadLogMedia',
      '$BASE_URL/farm-manager/logs/uploadLogMedia',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'uploadLogMedia',
      '$BASE_URL/farm-manager/logs/uploadLogMedia',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  return result;
}

Future<bool> uploadLogFile(UploadAssetResource request) async {
  debugPrint('upload log file');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/logs/uploadLogFile'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'uploadLogFile',
      '$BASE_URL/farm-manager/logs/uploadLogFile',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('File Uploaded'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'uploadLogFile',
      '$BASE_URL/farm-manager/logs/uploadLogFile',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'uploadLogFile',
      '$BASE_URL/farm-manager/logs/uploadLogFile',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  return result;
}

Future<bool> addLogOwner(CreateLogOwner request) async {
  debugPrint('add log owner');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/logs/addLogOwner'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'addLogOwner',
      '$BASE_URL/farm-manager/logs/addLogOwner',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Log Participant Added'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'addLogOwner',
      '$BASE_URL/farm-manager/logs/addLogOwner',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'addLogOwner',
      '$BASE_URL/farm-manager/logs/addLogOwner',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  return result;
}

Future<bool> addLogRemark(AddLogRemark request) async {
  debugPrint('add log remark');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/farm-manager/logs/addLogRemark'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request),
  );
  OneContext().hideProgressIndicator();
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'addLogRemark',
      '$BASE_URL/farm-manager/log/addLogRemark',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Log Remark Added'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'addLogRemark',
      '$BASE_URL/farm-manager/logs/addLogRemark',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'addLogRemark',
      '$BASE_URL/farm-manager/logs/addLogRemarkk',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  return result;
}

Future<AdditionalLogDetails?> getAdditionalLogDetails(int logId) async {
  debugPrint('getting additional log details');
  AdditionalLogDetails? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/logs/getAdditionalLogDetails/$logId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getAdditionalLogDetails',
      '$BASE_URL/farm-manager/logs/getAdditionalLogDetails/$logId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = AdditionalLogDetails.fromJson(jsonDecode(response.body));
    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getAdditionalLogDetails',
      '$BASE_URL/farm-manager/logs/getAdditionalLogDetails/$logId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getAdditionalLogDetails',
      '$BASE_URL/farm-manager/logs/getAdditionalLogDetails/$logId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetLogDetails?> getLogDetails(int logId) async {
  debugPrint('getting log details');
  GetLogDetails? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/logs/getLogDetails/$logId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getLogDetails',
      '$BASE_URL/farm-manager/logs/getLogDetails/$logId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetLogDetails.fromJson(
      jsonDecode(response.body).map((model) => GetLogDetails.fromJson(model)),
    );
    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getLogDetails',
      '$BASE_URL/farm-manager/logs/getLogDetails/$logId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getLogDetails',
      '$BASE_URL/farm-manager/logs/getLogDetails/$logId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetLogsResponse?> getLogsInSite(String siteId) async {
  debugPrint('getting log in site');
  GetLogsResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/farm-manager/logs/findAllLogsInSite/$siteId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getLogsInSite',
      '$BASE_URL/farm-manager/logs/findAllLogsInSite/$siteId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetLogsResponse.fromJson(jsonDecode(response.body));
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getLogsInSite',
      '$BASE_URL/farm-manager/logs/findAllLogsInSite/$siteId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getLogsInSite',
      '$BASE_URL/farm-manager/logs/findAllLogsInSite/$siteId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetLogsResponse?> getLogsInSiteByType(
  String siteId,
  String logType,
) async {
  debugPrint('getting log in site by type');
  GetLogsResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/farm-manager/logs/findAllLogsInSiteByLogType/$siteId/$logType',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getLogsInSiteByType',
      '$BASE_URL/farm-manager/logs/findAllLogsInSiteByLogType/$siteId/$logType',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetLogsResponse.fromJson(jsonDecode(response.body));
    //   return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getLogsInSiteByType',
      '$BASE_URL/farm-manager/logs/findAllLogsInSiteByLogType/$siteId/$logType',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getLogsInSiteByType',
      '$BASE_URL/farm-manager/logs/findAllLogsInSiteByLogType/$siteId/$logType',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetLogsResponse?> getLogsInAssetBySiteAndType(
  int assetId,
  String siteId,
  String logType,
) async {
  debugPrint('getting log in asset by site and by type');
  GetLogsResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/farm-manager/logs/findAllLogsInAssetByLogType/$assetId/$siteId/$logType',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getLogsInAssetBySiteAndType',
      '$BASE_URL/farm-manager/logs/findAllLogsInAssetByLogType/$assetId/$siteId/$logType',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    debugPrint("$assetId , $siteId , $logType");
    result = GetLogsResponse.fromJson(jsonDecode(response.body));
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getLogsInAssetBySiteAndType',
      '$BASE_URL/farm-manager/logs/findAllLogsInAssetByLogType/$assetId/$siteId/$logType',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getLogsInAssetBySiteAndType',
      '$BASE_URL/farm-manager/logs/findAllLogsInAssetByLogType/$assetId/$siteId/$logType',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetFieldAgentStatisticsResponse?> getFieldAgentStatistics(
  String agentId,
) async {
  debugPrint('getting field agent statistics');
  GetFieldAgentStatisticsResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/farm-manager/dashboard/getFieldAgentDashboardStatistics/$agentId',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'getFieldAgentStatistics',
      '$BASE_URL/farm-manager/logs/field-agent-config/findAllOrganizationsForFieldAgentsById/$agentId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetFieldAgentStatisticsResponse.fromJson(jsonDecode(response.body));
    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'getFieldAgentStatistics',
      '$BASE_URL/farm-manager/logs/field-agent-config/findAllOrganizationsForFieldAgentsById/$agentId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'getFieldAgentStatistics',
      '$BASE_URL/farm-manager/logs/field-agent-config/findAllOrganizationsForFieldAgentsById/$agentId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}
