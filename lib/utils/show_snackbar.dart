import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(String message) {
  Get.showSnackbar(GetSnackBar(
    duration: const Duration(milliseconds: 2000),
    message: message,
    dismissDirection: DismissDirection.horizontal,
  ));
}
