import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/institution/data/model/institution_org_response.dart';
import 'package:smat_crow/features/institution/data/model/invite_response.dart';
import 'package:smat_crow/features/institution/data/repository/institution_repository.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final institutionProvider = ChangeNotifierProvider<InstitutionNotifier>((ref) {
  return InstitutionNotifier(ref);
});

enum UserRole { institution, admin, user, agent }

class InstitutionNotifier extends ChangeNotifier {
  final Ref ref;

  InstitutionNotifier(this.ref);
  final _pandora = Pandora();

  bool _loading = false;
  bool get loading => _loading;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  bool _loader = false;
  bool get loader => _loader;

  set loader(bool val) {
    _loader = val;
    notifyListeners();
  }

  bool _showSiteMenu = false;
  bool get showSiteMenu => _showSiteMenu;
  set showSiteMenu(bool state) {
    _showSiteMenu = state;
    notifyListeners();
  }

  int _selectedMenu = 0;
  int get selectedMenu => _selectedMenu;
  set selectedMenu(int value) {
    _selectedMenu = value;
    notifyListeners();
  }

  List<InstitutionOrgResponse> _institutionOrgList = [];
  List<InstitutionOrgResponse> get institutionOrgList => _institutionOrgList;

  set institutionOrgList(List<InstitutionOrgResponse> list) {
    _institutionOrgList = list;
    notifyListeners();
  }

  InstOrganization? _instOrganization;
  InstOrganization? get instOrganization => _instOrganization;
  set instOrganization(InstOrganization? org) {
    _instOrganization = org;
    notifyListeners();
  }

  List<InviteResponse> _sentInviteList = [];
  List<InviteResponse> get sentInviteList => _sentInviteList;
  set sentInviteList(List<InviteResponse> list) {
    _sentInviteList = list;
    notifyListeners();
  }

  Future<void> getInstitutionOrg() async {
    loading = true;
    try {
      final resp = await locator
          .get<InstitutionRepository>()
          .getInstitutionOrg(instId: ref.read(sharedProvider).userInfo!.user.id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        _institutionOrgList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_INSTITUTION_ORGANIZATION',
        '${ApiClient().baseUrl}/farm-manager/institution/organizations/instId',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> inviteOrganization(String email) async {
    await OneContext().showProgressIndicator();
    try {
      if (ref.read(sharedProvider).userInfo == null) return;
      final resp = await locator
          .get<InstitutionRepository>()
          .inviteOrganization(email, ref.read(sharedProvider).userInfo!.user.id);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        snackBarMsg(resp.response);
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'INVITE_ORGANIZATION',
        '${ApiClient().baseUrl}/farm-manager/institution/inviteOrganizations',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> inviteInstitution(String email, String id) async {
    loading = true;
    try {
      final resp = await locator.get<InstitutionRepository>().inviteInstitution(email, id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {}
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'INVITE_INSTITUTION',
        '${ApiClient().baseUrl}/farm-manager/institution/inviteInstitutions',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> sentInstitutions() async {
    loading = true;
    try {
      if (ref.read(sharedProvider).userInfo == null) {
        loading = false;
        return;
      }
      final resp =
          await locator.get<InstitutionRepository>().sentinvitation(ref.read(sharedProvider).userInfo!.user.id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        sentInviteList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'INVITE_INSTITUTION',
        '${ApiClient().baseUrl}/farm-manager/institution/inviteInstitutions',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> cancelInvitation(String email, String id) async {
    loader = true;
    try {
      if (ref.read(sharedProvider).userInfo == null) {
        loading = false;
        return;
      }
      final resp = await locator
          .get<InstitutionRepository>()
          .cancelInvitation(email, ref.read(sharedProvider).userInfo!.user.id, id);
      loader = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {}
    } catch (e) {
      loader = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CANCEL_INSTITUTION',
        '${ApiClient().baseUrl}/farm-manager/institution/cancelInstitutions',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> detachOrganization(String orgId) async {
    await OneContext().showProgressIndicator();
    try {
      final resp =
          await locator.get<InstitutionRepository>().detachOrg(orgId, ref.read(sharedProvider).userInfo!.user.id);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        snackBarMsg("Organization Removed", type: SnackBarType.success);
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CANCEL_INSTITUTION',
        '${ApiClient().baseUrl}/farm-manager/institution/cancelInstitutions',
        "error",
        e.toString(),
      );
    }
  }
}
