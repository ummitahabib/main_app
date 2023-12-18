import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/request/mailer/send_mail_request.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../utils/constants.dart';

Pandora _pandora = Pandora();

///* Send Email
///
Future<bool> sendMail(SendMailRequest sendMailRequest, File myFile) async {
  debugPrint('publish asset');
  await OneContext().showProgressIndicator();
  bool result;

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$BASE_URL/mailer/sendWithAttachment'),
  );
  request.fields.addAll({
    'request':
        '{   "body": "${sendMailRequest.body}",   "cc": ${sendMailRequest.cc},   "from": "${sendMailRequest.from}",   "subject": "${sendMailRequest.subject}",   "to": "${sendMailRequest.to}" }'
  });
  request.files.addAll([await http.MultipartFile.fromPath('attachments', myFile.path)]);
  final http.StreamedResponse response = await request.send();
  OneContext().hideProgressIndicator();
  log(response.statusCode.toString());
  if (response.statusCode == HttpStatus.ok ||
      response.statusCode == HttpStatus.created ||
      response.statusCode == HttpStatus.noContent) {
    _pandora.logAPIEvent(
      'sendMail',
      '$BASE_URL/mailer/sendWithAttachment',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Mail Sent'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'sendMail',
      '$BASE_URL/mailer/sendWithAttachment',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else if (response.statusCode == HttpStatus.badRequest) {
    _pandora.logAPIEvent(
      'sendMail',
      '$BASE_URL/mailer/sendWithAttachment',
      'FAILED',
      HttpStatus.badRequest.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text("Send Mail Failed")),
    );
  } else {
    _pandora.logAPIEvent(
      'sendMail',
      '$BASE_URL/mailer/sendWithAttachment',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text("Send Mail Failed")),
    );
  }
  OneContext().hideProgressIndicator();
  return result;
}
