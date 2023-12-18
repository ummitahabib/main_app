import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

Pandora _pandora = Pandora();

Future<bool> processImagesInBatch(String batchId) async {
  debugPrint('processing images in batch');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.put(
    Uri.parse('$BASE_URL/org/smatmapper/batches/$batchId/startprocessing'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'PROCESS_BATCH_IMAGES',
      '$BASE_URL/org/smatmapper/batches/$batchId/startprocessing',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Batch is processing'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'PROCESS_BATCH_IMAGES',
      '$BASE_URL/org/smatmapper/batches/$batchId/startprocessing',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'PROCESS_BATCH_IMAGES',
      '$BASE_URL/org/smatmapper/batches/$batchId/startprocessing',
      'FAILED',
      response.statusCode.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Batch processing failed'),
        backgroundColor: Colors.red,
      ),
    );
    result = false;
  }
  OneContext().hideProgressIndicator();
  return result;
}
