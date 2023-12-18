import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/subcription/create_subscriber.dart';
import 'package:smat_crow/network/crow/models/subcription/subscription.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../../network/crow/models/subcription/subscription_plan.dart';

class SubscriptionsService {
  final Pandora _pandora = Pandora();

  Future<List<SubscriptionPlan>> getPlans() async {
    debugPrint("calling get plans");
    List<SubscriptionPlan> result = [];

    final response = await http.get(Uri.parse("$BASE_URL/smatsub/plans/subscribable-plans?size=30&status=ACTIVE"));

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      _pandora.logAPIEvent(
        'GET_SUBSCRIPTION_PLANS',
        '$BASE_URL/smatsub/plans/subscribable-plans',
        response.statusCode.toString(),
        '',
      );

      // log(response.body);

      result = List<SubscriptionPlan>.from(
        jsonDecode(response.body).map((model) => SubscriptionPlan.fromJson(model)),
      );
    } else if (response.statusCode == HttpStatus.badRequest) {
      _pandora.logAPIEvent(
        'GET_SUBSCRIPTION_PLANS',
        '$BASE_URL/smatsub/plans/subscribable-plans',
        'FAILED',
        response.statusCode.toString(),
      );
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(content: Text('Something went wrong')),
      );

      // result = [];
    }
    return result;
  }

  Future<List<Subscription>> getSubscriberSubscriptions(String uid) async {
    List<Subscription> result = [];

    try {
      final response =
          await http.get(Uri.parse("$BASE_URL/smatsub/subscribers/$uid/subscriptions?page=0&size=20&sort=id,ASC"));

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        _pandora.logAPIEvent(
          'GET_SUBSCRIBER_SUBSCRIPTIONS',
          '$BASE_URL/smatsub/subscribers/$uid/subscriptions',
          response.statusCode.toString(),
          'success',
        );

        result = List<Subscription>.from(
          jsonDecode(response.body).map((model) => Subscription.fromJson(model)),
        );
      } else if (response.statusCode == HttpStatus.badRequest) {
        _pandora.logAPIEvent(
          'GET_SUBSCRIBER_SUBSCRIPTIONS',
          '$BASE_URL/smatsub/subscribers/$uid/subscriptions',
          'FAILED',
          response.statusCode.toString(),
        );
        await OneContext().showSnackBar(
          builder: (_) => const SnackBar(content: Text('Something went wrong')),
        );
      } else {
        _pandora.logAPIEvent(
          'GET_SUBSCRIBER_SUBSCRIPTIONS',
          '$BASE_URL/smatsub/subscribers/$uid/subscriptions',
          'FAILED',
          response.statusCode.toString(),
        );
        await OneContext().showSnackBar(
          builder: (_) => SnackBar(content: Text(response.statusCode.toString())),
        );
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_SUBSCRIBER_SUBSCRIPTIONS',
        '$BASE_URL/smatsub/subscribers/$uid/subscriptions',
        'FAILED',
        e.toString(),
      );
      await OneContext().showSnackBar(
        builder: (_) => SnackBar(content: Text(e.toString())),
      );
    }

    return result;
  }

  // Future<bool> subscribeToPlan(
  //   String planCode,
  //   SubscriptionRequest request,
  // ) async {
  //   bool requestSuccessful = false;

  //   log("$BASE_URL/smatsub/plans/$planCode/subscribe");
  //   log("Subscribing to plan $planCode");
  //   log("Plan subscription payload: ${request.toJson()}");

  //   final response = await http.post(
  //     Uri.parse("$BASE_URL/smatsub/plans/$planCode/subscribe"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       // 'Authorization': 'Bearer ' + Session.SessionToken,
  //     },
  //     body: jsonEncode(
  //       <String, dynamic>{
  //         "autoRenew": true,
  //         "isLocal": true,
  //         "paymentRef": request.paymentRef,
  //         "planIntervals": request.planIntervals,
  //         "user": request.user,
  //       },
  //     ),
  //   );

  //   log(response.statusCode.toString());
  //   log("$BASE_URL/smatsub/plans/$planCode/subscribe");

  //   if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.accepted) {
  //     _pandora.logAPIEvent(
  //       'SUBSCRIBE_TO_PLAN',
  //       '$BASE_URL/smatsub/plans/$planCode/subscribe',
  //       response.statusCode.toString(),
  //       '',
  //     );

  //     log(response.body);

  //     requestSuccessful = true;
  //   } else if (response.statusCode == HttpStatus.badRequest) {
  //     _pandora.logAPIEvent(
  //       'SUBSCRIBE_TO_PLAN',
  //       '$BASE_URL/smatsub/plans/$planCode/subscribe',
  //       'FAILED',
  //       response.statusCode.toString(),
  //     );
  //     await OneContext().showSnackBar(
  //       builder: (_) => const SnackBar(content: Text('Something went wrong')),
  //     );

  //     // result = [];
  //   }

  //   log(response.body);
  //   log(response.statusCode.toString());

  //   return requestSuccessful;
  // }

  Future<bool> cancelSubscription(String subscriptionCode, String uid) async {
    bool requestSuccessful = false;

    final response = await http.post(
      Uri.parse("$BASE_URL/smatsub/subscriptions/$subscriptionCode/cancel?uid=$uid"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer ' + Session.SessionToken,
      },
      body: jsonEncode(<String, dynamic>{}),
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.accepted) {
      _pandora.logAPIEvent(
        'CANCEL_SUBSCRIPTION',
        '$BASE_URL/smatsub/subscriptions/$subscriptionCode/cancel?uid=$uid',
        response.statusCode.toString(),
        '',
      );

      log(response.body);

      requestSuccessful = true;
    } else if (response.statusCode == HttpStatus.badRequest) {
      _pandora.logAPIEvent(
        'CANCEL_SUBSCRIPTION',
        '$BASE_URL/smatsub/subscriptions/$subscriptionCode/cancel?uid=$uid',
        'FAILED',
        response.statusCode.toString(),
      );
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(content: Text('Something went wrong')),
      );

      // result = [];
    }

    return requestSuccessful;
  }

  Future<bool> createSubscriber(CreateSubscriberRequest request) async {
    bool requestSuccessful = false;
    final token = await Pandora().getFromSharedPreferences("token");
    final response = await http.post(
      Uri.parse("$BASE_URL/smatsub/subscribers"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.accepted) {
      _pandora.logAPIEvent(
        'CREATE_SUBSCRIBER',
        '$BASE_URL/smatsub/subscribers',
        response.statusCode.toString(),
        '',
      );

      log(response.body);

      requestSuccessful = true;
    } else if (response.statusCode == HttpStatus.badRequest) {
      _pandora.logAPIEvent(
        'CREATE_SUBSCRIBER',
        '$BASE_URL/smatsub/subscribers',
        'FAILED',
        response.statusCode.toString(),
      );
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(content: Text('Something went wrong')),
      );

      // result = [];
    }

    return requestSuccessful;
  }
}
