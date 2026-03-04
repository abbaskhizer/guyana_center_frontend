import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/billing_history.dart';
import 'package:guyana_center_frontend/modal/payment_method.dart';

class BillingController extends GetxController {
  // Current plan
  final planName = "Pro Digital".obs;
  final planDesc = "Unlimited pins · Priority support · Premium badges".obs;
  final planPrice = "\$20/mo".obs;

  // Payment methods
  final methods = <PaymentMethod>[
    PaymentMethod(
      brand: "VISA",
      number: "**** 4242",
      expiry: "Exp 08/26",
      colorHex: 0xFF2563EB, // blue
      isDefault: true,
    ),
    PaymentMethod(
      brand: "MC",
      number: "**** 8831",
      expiry: "Exp 11/25",
      colorHex: 0xFFF97316, // orange
      isDefault: false,
    ),
  ].obs;

  // History
  final history = <BillingHistory>[
    BillingHistory(
      title: "Pro Plan · Monthly",
      date: "Jan 15, 2024",
      amount: "\$20.00",
      status: "DUE",
    ),
    BillingHistory(
      title: "Pro Plan · Monthly",
      date: "Dec 15, 2024",
      amount: "\$20.00",
      status: "PAID",
    ),
    BillingHistory(
      title: "Pro Plan · Monthly",
      date: "Nov 15, 2024",
      amount: "\$20.00",
      status: "PAID",
    ),
    BillingHistory(
      title: "Pro Plan · Monthly",
      date: "Oct 15, 2024",
      amount: "\$20.00",
      status: "PAID",
    ),
    BillingHistory(
      title: "Pro Plan · Monthly",
      date: "Sep 15, 2024",
      amount: "\$20.00",
      status: "PAID",
    ),
  ].obs;

  // Billing Address
  final billingName = "Nasha Montone".obs;
  final billingLine1 = "1234 Innovation Drive".obs;
  final billingLine2 = "San Jose, CA 95134".obs;

  // Actions
  void changePlan() {
    Get.snackbar("Plan", "Change plan tapped");
  }

  void upgradeEnterprise() {
    Get.snackbar("Upgrade", "Upgrade to Enterprise tapped");
  }

  void addPaymentMethod() {
    Get.snackbar("Payment", "Add payment method tapped");
  }

  void setDefaultMethod(int index) {
    final updated = methods.map((m) => m.copyWith(isDefault: false)).toList();
    updated[index] = updated[index].copyWith(isDefault: true);
    methods.assignAll(updated);
  }
}
