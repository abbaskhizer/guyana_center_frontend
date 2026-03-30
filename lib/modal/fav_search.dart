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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'alertsOn': alertsOn.value,
    };
  }

  factory SavedSearchItem.fromJson(Map<String, dynamic> json) {
    return SavedSearchItem(
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      alertsOn: json['alertsOn'] ?? true,
    );
  }
}
