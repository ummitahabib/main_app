import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/repository/organisation_repository.dart';
import 'package:smat_crow/features/shared/data/controller/firebase_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/network/crow/models/industries_response.dart';
import 'package:smat_crow/network/crow/models/organization_by_id_response.dart';
import 'package:smat_crow/network/crow/models/organizations_response.dart';
import 'package:smat_crow/network/crow/models/request/create_organization.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';
import 'package:universal_html/html.dart' as html;

final organizationProvider = ChangeNotifierProvider<OrganizationNotifier>(
  (ref) => OrganizationNotifier(ref),
);

class OrganizationNotifier extends ChangeNotifier {
  final Ref ref;
  OrganizationNotifier(this.ref);

  bool _loading = false;
  bool get loading => _loading;

  bool _visible = false;
  bool get visible => _visible;
  final _pandora = Pandora();

  GetOrganizationById? _organization;
  GetOrganizationById? get organization => _organization;

  List<GetUserOrganizations> _organizationList = [];
  List<GetUserOrganizations> get organizationList => _organizationList;

  List<GetIndustriesResponse> _industriesList = [];
  List<GetIndustriesResponse> get industriesList => _industriesList;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  set visible(bool state) {
    _visible = state;
    notifyListeners();
  }

  set organization(GetOrganizationById? org) {
    _organization = org;
    notifyListeners();
  }

  set industriesList(List<GetIndustriesResponse> list) {
    _industriesList = list;
    notifyListeners();
  }

  set organizationList(List<GetUserOrganizations> list) {
    _organizationList = list;
    notifyListeners();
  }

  Future<void> getUserOrganizations() async {
    loading = true;
    try {
      if (ref.read(sharedProvider).userInfo == null) {
        loading = false;
        return;
      }
      final resp =
          await locator.get<OrganizationRepostiory>().getUserOrganisations(ref.read(sharedProvider).userInfo!.user.id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        organizationList = resp.response;
        organizationList = organizationList.reversed.toList();
        // organizationList.sort(
        //   (a, b) => int.parse(b.createdAt.toString().substring(0, 10).split("-").join())
        //       .compareTo(int.parse(a.createdAt.toString().substring(0, 10).split("-").join())),
        // );
      }
    } catch (e) {
      loading = false;
      _pandora.logAPIEvent(
        'GET_USER_ORGANIZATIONS',
        '$BASE_URL/org/organizations/user/id',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getOrganizationById(String id) async {
    try {
      final resp = await locator.get<OrganizationRepostiory>().getOrganisationById(id);

      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        organization = resp.response;
      }
    } catch (e) {
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ORGANIZATIONS_BY_ID',
        '$BASE_URL/org/organizations/$id',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getIndustries() async {
    try {
      final resp = await locator.get<OrganizationRepostiory>().getAllIndustries();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        industriesList = resp.response;
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ALL_INDUSTRIES',
        '$BASE_URL/in/industries',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> createOrganization(CreateOrganizationRequest req) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<OrganizationRepostiory>().createOrganisation(req);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await getUserOrganizations();
        snackBarMsg(organizationCreated, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());

      _pandora.logAPIEvent(
        'CREATE_ORGANIZATION',
        '$BASE_URL/org/organizations',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateOrganization(CreateOrganizationRequest req, String id) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<OrganizationRepostiory>().updateOrganisationById(id, req);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg(organizationUpdated, type: SnackBarType.success);

        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'UPDATE_ORGANIZATION',
        '$BASE_URL/org/organizations/$id',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteOrganization(String id) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<OrganizationRepostiory>().deleteOrganisationById(id);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await getUserOrganizations();
        snackBarMsg(organizationDeleted, type: SnackBarType.success);

        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'DELETE_ORGANIZATION',
        '$BASE_URL/org/organizations/$id',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> createOrUpdateOrganization(
    BuildContext context,
    WidgetRef ref,
    GetOrganizationById? org,
    CreateOrganizationRequest request,
  ) async {
    if (org != null) {
      Pandora().logAPPButtonClicksEvent('UPDATE_ORGANIZATION');
      await updateOrganization(request, org.id ?? "").then((value) {
        if (value) {
          Navigator.pop(context);
        }
      });
    } else {
      Pandora().logAPPButtonClicksEvent('CREATE_ORGANIZATION');
      await createOrganization(request).then((value) {
        if (value) {
          Navigator.pop(context);
        }
      });
    }
  }

  Future<String?> uploadToFirebase([String folderPath = "organization"]) async {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.click();
      uploadInput.accept = 'image/*'; // You can set the file type you want to accept
      uploadInput.onChange.listen((event) {
        if (uploadInput.files != null) {
          final file = uploadInput.files!.first;
          ref.read(firebaseProvider).uploadWebFileToFirebase(file, folderPath: folderPath).then((value) {
            return value;
          });
        }
      });
    } else {
      await ref.read(firebaseProvider).uploadImageToFirebase(folderPath).then((value) {
        return value;
      });
    }
    return null;
  }
}

enum SnackBarType { success, error }

void snackBarMsg(
  String message, {
  SnackBarType type = SnackBarType.error,
}) {
  return Pandora().displayToast(message, type == SnackBarType.success ? Colors.green : AppColors.SmatCrowRed500);
}
