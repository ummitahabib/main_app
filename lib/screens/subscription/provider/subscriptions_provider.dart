import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/network/crow/models/subcription/create_subscriber.dart';
import 'package:smat_crow/network/crow/models/subcription/subscription.dart';
import 'package:smat_crow/screens/subscription/provider/subscriptions_service.dart';

import '../../../network/crow/models/subcription/subscription_plan.dart';

final subcriptionProvider = ChangeNotifierProvider<SubscriptionsProvider>((ref) {
  return SubscriptionsProvider();
});

class SubscriptionsProvider extends ChangeNotifier {
  final SubscriptionsService _service = SubscriptionsService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  final bool _subscriptionRequestSuccessful = false;
  bool _cancelSubscriptionRequestSuccessful = false;
  List<SubscriptionPlan> _plans = [];
  List<Subscription> _subscriptions = [];

  bool get subscriptionRequestSuccessful => _subscriptionRequestSuccessful;
  bool get cancelSubscriptionRequestSuccessful => _cancelSubscriptionRequestSuccessful;
  List<SubscriptionPlan> get plans => _plans;
  List<Subscription> get subscriptions => _subscriptions;

  /// get all available plans
  Future<void> getPlans() async {
    isLoading = true; // use isLoading
    try {
      final response = await _service.getPlans();
      _plans = response;
      notifyListeners();
      isLoading = false;
    } catch (e) {
      snackBarMsg(e.toString());
      isLoading = false;
    }
  }

  /// get all user's subscriptions by the user's uid
  Future<void> getSubscriptions(String uid) async {
    isLoading = true; // use isLoading
    try {
      final response = await _service.getSubscriberSubscriptions(uid);
      _subscriptions = response;
      notifyListeners();
      isLoading = false;
    } catch (e) {
      snackBarMsg(e.toString());
      isLoading = false;
    }
  }

  Future<bool> createSubscriber(CreateSubscriberRequest request) async {
    loading = true; // use isLoading
    try {
      final response = await _service.createSubscriber(request);
      loading = false;
      return response;
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
    }
    return false;
  }

  /// Subscribe to plan
  // Future<void> subscribeToPlan(String planCode, SubscriptionRequest request) async {
  //   isLoading = true;
  //   final response = await _service.subscribeToPlan(planCode, request);
  //   log("subscribe plan response $response");
  //   _subscriptionRequestSuccessful = response;
  //   notifyListeners();
  //   notifyListeners();
  // }

  /// Cancel Subscription
  Future<void> cancelSubscription(String subscriptionCode, String uid) async {
    isLoading = true;
    final response = await _service.cancelSubscription(subscriptionCode, uid);
    _cancelSubscriptionRequestSuccessful = response;
    notifyListeners();
    notifyListeners();
  }
}
