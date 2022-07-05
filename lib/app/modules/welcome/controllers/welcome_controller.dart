import 'dart:async';

import 'package:get/get.dart';
import 'package:get_ongkir/app/routes/app_pages.dart';
import 'package:http/http.dart';

class WelcomeController extends GetxController {
  void onReady() {
    super.onReady();
    loading();
  }

  Future<void> loading() async {
    Timer(const Duration(seconds: 5), () {
      Get.offAndToNamed(Routes.HOME);
    });
  }
}
