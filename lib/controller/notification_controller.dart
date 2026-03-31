import 'dart:async';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/notification_vm.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';

class NotificationController extends GetxController {
  final notifications = <AppNotification>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  Timer? _pollTimer;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    _startPolling();
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (AuthService.to.isLoggedIn.value) {
        _fetchUnreadCountOnly();
      }
    });
  }

  Future<void> _fetchUnreadCountOnly() async {
    try {
      final result = await ApiService.getUnreadNotificationCount(
        AuthService.to.accessToken.value,
      );
      if (result != null && result['unreadCount'] != null) {
        final newCount = result['unreadCount'] as int;
        if (newCount != unreadCount.value) {
          unreadCount.value = newCount;
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> fetchNotifications() async {
    if (!AuthService.to.isLoggedIn.value) return;

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final result = await ApiService.getNotifications(
        AuthService.to.accessToken.value,
      );

      if (result != null && result['notifications'] != null) {
        final list = result['notifications'] as List;
        notifications.value = list
            .map(
              (json) => AppNotification.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        unreadCount.value = result['unreadCount'] ?? 0;
      } else if (result != null && result is List) {
        notifications.value = result
            .map(
              (json) => AppNotification.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        unreadCount.value = notifications
            .where((n) => n.status == NotificationStatus.unread)
            .length;
      } else {
        hasError.value = true;
        errorMessage.value =
            result?['message'] ?? 'Failed to load notifications';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    if (!AuthService.to.isLoggedIn.value) return;

    isRefreshing.value = true;
    try {
      final result = await ApiService.getNotifications(
        AuthService.to.accessToken.value,
      );

      if (result != null && result['notifications'] != null) {
        final list = result['notifications'] as List;
        notifications.value = list
            .map(
              (json) => AppNotification.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        unreadCount.value = result['unreadCount'] ?? 0;
      }
    } catch (e) {
      // Silently fail on refresh
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await ApiService.markNotificationAsRead(
        AuthService.to.accessToken.value,
        notificationId,
      );

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notif = notifications[index];
        notifications[index] = AppNotification(
          id: notif.id,
          type: notif.type,
          status: NotificationStatus.read,
          title: notif.title,
          message: notif.message,
          reportId: notif.reportId,
          listingId: notif.listingId,
          listingTitle: notif.listingTitle,
          createdAt: notif.createdAt,
        );
        unreadCount.value = (unreadCount.value - 1).clamp(0, 999);
      }
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await ApiService.markAllNotificationsAsRead(
        AuthService.to.accessToken.value,
      );

      notifications.value = notifications
          .map(
            (n) => AppNotification(
              id: n.id,
              type: n.type,
              status: NotificationStatus.read,
              title: n.title,
              message: n.message,
              reportId: n.reportId,
              listingId: n.listingId,
              listingTitle: n.listingTitle,
              createdAt: n.createdAt,
            ),
          )
          .toList();
      unreadCount.value = 0;
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> dismissNotification(int notificationId) async {
    try {
      await ApiService.deleteNotification(
        AuthService.to.accessToken.value,
        notificationId,
      );
      notifications.removeWhere((n) => n.id == notificationId);
    } catch (e) {
      // Silently fail
    }
  }

  void handleNotificationTap(AppNotification notification) {
    if (notification.status == NotificationStatus.unread) {
      markAsRead(notification.id);
    }
  }

  void addNotificationFromSocket(Map<String, dynamic> data) {
    try {
      final notif = AppNotification.fromJson(data);
      notifications.insert(0, notif);
      unreadCount.value++;
    } catch (e) {
      // Ignore malformed socket data
    }
  }
}
