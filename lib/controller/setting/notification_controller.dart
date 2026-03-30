import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Email
  final emailPinActivity = true.obs;
  final emailComments = true.obs;
  final emailFollowers = false.obs;
  final emailNewsletter = true.obs;

  // Push
  final pushLikes = true.obs;
  final pushComments = true.obs;
  final pushMentions = true.obs;
  final pushFollowers = false.obs;

  // In-App
  final inAppActivity = true.obs;
  final inAppProductUpdates = false.obs;
}
