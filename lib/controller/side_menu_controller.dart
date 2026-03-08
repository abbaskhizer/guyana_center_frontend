import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenuController extends GetxController {
  final menuItems = <String>[
    'Home',
    'Browse Listings',
    'Categories',
    'Pricing',
    'About',
    'Contact',
  ];

  final selectedIndex = 0.obs;

  void selectMenu(int index) {
    selectedIndex.value = index;
  }

  void onLoginTap() {
    Get.snackbar('Login', 'Login tapped');
  }

  void onCreateAdTap() {
    Get.snackbar('Create Ad', 'Create Ad tapped');
  }

  void onSignInTap() {
    Get.snackbar('Signin', 'Signin tapped');
  }
}
