import 'package:get/get.dart';
import 'package:guyana_center_frontend/modal/chat_user.dart';

class MessagesController extends GetxController {
  final selectedChatIndex = 0.obs;
  final messageText = ''.obs;

  final chats = <ChatUser>[
    ChatUser(
      name: 'Marissa Maharaj',
      subtitle: "Yes, I'll send you the location...",
      itemTitle: 'Toyota Hiace, 2014',
      price: '\$180,000',
      time: '2:40 PM',
      isOnline: true,
      unreadCount: 1,
    ),
    ChatUser(
      name: 'Andre Haddad',
      subtitle: "Still available? What's the lowest you'll take?",
      itemTitle: 'iPhone 15 Pro Max',
      price: '\$8,500',
      time: '11:20 AM',
    ),
    ChatUser(
      name: 'Keron Baptiste',
      subtitle: "Thanks, I'll think about it.",
      itemTitle: '2BR Apt in Chaguanas',
      price: '\$4,500/mo',
      time: 'Yesterday',
    ),
    ChatUser(
      name: 'Priya Ramsaran',
      subtitle: 'Is delivery available to San Fernando?',
      itemTitle: 'Samsung 65" Smart TV',
      price: '\$5,200',
      time: 'Yesterday',
      unreadCount: 2,
    ),
    ChatUser(
      name: 'Jason Mohammed',
      subtitle: 'Ok deal! Let me know when to collect.',
      itemTitle: 'Gaming PC Setup',
      price: '\$12,000',
      time: 'Mon',
    ),
  ].obs;

  final messages = <ChatMessage>[
    ChatMessage(
      text:
          'Hi Yes, the Hiace is still available. Would you like to come see it?',
      time: '2:30 PM',
      isMe: false,
    ),
    ChatMessage(
      text:
          'Great! Is the price negotiable? I can come check it out this weekend.',
      time: '2:32 PM',
      isMe: true,
    ),
    ChatMessage(
      text:
          'I can do \$170,000 without the music system. The vehicle is fully inspected and ready for transfer.',
      time: '2:35 PM',
      isMe: false,
    ),
    ChatMessage(
      text: 'That sounds fair. Can I see it Saturday morning around 10am?',
      time: '2:38 PM',
      isMe: true,
    ),
    ChatMessage(
      text:
          "Saturday works! I'll send you the location. It's in Port of Spain, near the Savannah.",
      time: '2:40 PM',
      isMe: false,
    ),
    ChatMessage(
      text:
          'Perfect, see you then! One more question - does it have a valid inspection sticker?',
      time: '3:15 PM',
      isMe: true,
    ),
  ].obs;

  ChatUser get selectedChat => chats[selectedChatIndex.value];

  void selectChat(int index) {
    selectedChatIndex.value = index;
  }

  void sendMessage(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;

    messages.add(ChatMessage(text: trimmed, time: 'Now', isMe: true));
    messageText.value = '';
  }
}
