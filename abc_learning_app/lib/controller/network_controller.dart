import 'package:abc_learning_app/page/no_network_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      if (Get.currentRoute != NoInteretPage.routeName) {
        Navigator.of(Get.context!).pushNamed(NoInteretPage.routeName);
      }
    } else {
      if (Get.currentRoute == NoInteretPage.routeName) {
        Get.back();
      }
    }
  }
}
