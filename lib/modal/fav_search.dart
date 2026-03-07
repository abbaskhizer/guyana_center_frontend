import 'package:get/get.dart';

class SavedSearchItem {
  final String title;
  final String icon;
  RxBool alertsOn;

  SavedSearchItem({
    required this.title,
    required this.icon,
    bool alertsOn = true,
  }) : alertsOn = alertsOn.obs;
}
