import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/models/batch_by_id.dart';
import 'package:smat_crow/features/organisation/data/repository/batch_repository.dart';
import 'package:smat_crow/network/crow/models/request/create_batch.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final batchProvider = ChangeNotifierProvider<BatchNotifier>((ref) {
  return BatchNotifier(ref);
});

class BatchNotifier extends ChangeNotifier {
  final Ref ref;

  BatchNotifier(this.ref);

  bool _loading = false;
  bool get loading => _loading;

  List<BatchById> _batchList = [];
  List<BatchById> get batchList => _batchList;

  BatchById? _batch;
  BatchById? get batch => _batch;

  bool _showBatchInfo = false;
  bool get showBatchInfo => _showBatchInfo;

  set showBatchInfo(bool state) {
    _showBatchInfo = state;
    notifyListeners();
  }

  set batch(BatchById? bth) {
    _batch = bth;
    notifyListeners();
  }

  final _pandora = Pandora();

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  set batchList(List<BatchById> list) {
    _batchList = list;
    notifyListeners();
  }

  Future<void> getSectorBatches(String sectorId) async {
    loading = true;
    try {
      final resp = await locator.get<BatchRepository>().getBatchesInSector(sectorId);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        batchList = resp.response;
        batchList.sort(
          (a, b) => int.parse(b.updatedAt.toString().substring(0, 10).split("-").join())
              .compareTo(int.parse(a.updatedAt.toString().substring(0, 10).split("-").join())),
        );
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SECTOR_BATCHES',
        '$BASE_URL/org/batches/sectors/$sectorId',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getBatchById(String id) async {
    loading = true;
    try {
      final resp = await locator.get<BatchRepository>().getBatchById(id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        batch = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_BATCH_BY_ID',
        '$BASE_URL/org/batches/$id',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> createBatch(CreateBatchRequest req, String image) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<BatchRepository>().createBatch(req);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await uploadBatch(resp.response.id, {
          "images": [image]
        });

        snackBarMsg(batchCreated, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CREATE_BATCH',
        '$BASE_URL/org/batches',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateBatch(String id, Map<String, dynamic> data) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<BatchRepository>().updateBatch(id, data);

      if (resp.hasError()) {
        OneContext().hideProgressIndicator();
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await getBatchById(id);
        await getSectorBatches(ref.read(sectorProvider).sector!.id);
        OneContext().hideProgressIndicator();
        snackBarMsg(batchUpdated, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'UPDATE_BATCH',
        '$BASE_URL/org/batches/$id',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteBatch(String id) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<BatchRepository>().deleteBatch(id);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await getSectorBatches(ref.read(sectorProvider).sector!.id);
        snackBarMsg(batchDeleted, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'DELETE_BATCH',
        '$BASE_URL/org/batches/$id',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> uploadBatch(String id, Map<String, dynamic> data) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<BatchRepository>().uploadBatch(id, data);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await getBatchById(id);
        await getSectorBatches(ref.read(sectorProvider).sector!.id);
        snackBarMsg(imageUploaded, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'UPLOAD_BATCH',
        '$BASE_URL/org/batches/$id',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> getBatchAnalysisType(String batchId, String analysisType) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<BatchRepository>().getBatchAnalysisType(batchId, analysisType);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg(batchUpdated, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_BATCH_ANALYSIS_TYPE',
        '$BASE_URL/org/batches/$batchId/analysis/$analysisType',
        'FAILED',
        e.toString(),
      );
      return false;
    }
  }
}
