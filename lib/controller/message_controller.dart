import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:guyana_center_frontend/modal/chat_user.dart';
import 'package:guyana_center_frontend/modal/socket_message.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:guyana_center_frontend/services/socket_service.dart';
import 'package:guyana_center_frontend/services/message_storage_service.dart';

class MessagesController extends GetxController {
  final SocketService _socketService = SocketService();
  final MessageStorageService _storageService = MessageStorageService();
  Worker? _tokenWorker;
  
  // Prevent concurrent refresh calls
  bool _isRefreshing = false;

  // Observable state
  final isLoading = false.obs;
  final isLoadingMessages = false.obs;
  final selectedChatIndex = 0.obs;
  final messageText = ''.obs;
  final conversations = <ChatUser>[].obs;
  final messages = <ChatMessage>[].obs;
  final currentConversationId = ''.obs;
  final otherUserId = ''.obs;
  final otherUserName = ''.obs;
  final otherUserPhotoUrl = ''.obs;
  final currentUserPhotoUrl = ''.obs;
  final isChatOpen = false.obs;

  int _findOptimisticMatchIndex({
    required String serverId,
    required String text,
    required String senderId,
    required DateTime serverTimestamp,
    required bool hasImage,
  }) {
    final normalizedText = text.trim();
    final now = DateTime.now();

    if (senderId != (currentUserId ?? '')) return -1;

    int bestIndex = -1;
    DateTime? bestTime;

    for (int i = messages.length - 1; i >= 0; i--) {
      final m = messages[i];
      if (!m.id.startsWith('temp_')) continue;
      if (m.senderId != senderId) continue;

      final mHasImage = (m.imagePath != null && m.imagePath!.toString().isNotEmpty) ||
          (m.imageUrl != null && m.imageUrl!.toString().isNotEmpty);
      if (mHasImage != hasImage) continue;

      if (normalizedText.isNotEmpty) {
        if (m.text.trim() != normalizedText) continue;
      } else {
        if (m.text.trim().isNotEmpty) continue;
      }

      final diff = m.timestamp.difference(serverTimestamp).abs();
      if (diff.inMinutes > 2) continue;

      final age = now.difference(m.timestamp).abs();
      if (age.inMinutes > 10) continue;

      if (bestTime == null || m.timestamp.isAfter(bestTime)) {
        bestTime = m.timestamp;
        bestIndex = i;
      }
    }

    return bestIndex;
  }

  void _removeOptimisticDuplicate({
    required String serverId,
    required String text,
    required String senderId,
    required DateTime serverTimestamp,
    required bool hasImage,
  }) {
    final idx = _findOptimisticMatchIndex(
      serverId: serverId,
      text: text,
      senderId: senderId,
      serverTimestamp: serverTimestamp,
      hasImage: hasImage,
    );
    if (idx != -1) {
      messages.removeAt(idx);
    }
  }

  // Listing context
  final listingIdValue = 0.obs;
  final listingTitleValue = ''.obs;
  final listingPriceValue = RxnDouble();
  final listingImagesValue = <String>[].obs;

  // Get current user ID
  String? get currentUserId => AuthService.to.userId.value?.toString();

  // Track current user to detect changes
  String? _lastUserId;

  @override
  void onInit() {
    super.onInit();
    connectSocket();
    loadConversations();
    loadCurrentUserPhoto();

    _tokenWorker = ever(AuthService.to.accessToken, (String token) {
      if (token.isEmpty) return;
      connectSocket();
    });
    
    // Listen to auth changes to clear data when user changes
    _lastUserId = currentUserId;
    ever(AuthService.to.userId, (userId) {
      final newUserId = userId?.toString();
      print('🔐 Auth changed: old=$_lastUserId, new=$newUserId');
      if (newUserId != _lastUserId) {
        print('🧹 User changed, clearing all chat data');
        clearUserData();
        _lastUserId = newUserId;
        if (newUserId != null) {
          loadConversations();
        }
      }
    });

    // Register global message listener for unread badges
    _socketService.onGlobalMessage((data) {
      final conversationId = data['conversationId']?.toString() ?? '';
      final senderId = data['senderId']?.toString() ?? '';
      final text = data['text']?.toString() ?? '';
      final isMe = senderId == currentUserId;
      
      print('🌎 Global message received: $conversationId, isMe: $isMe');

      if (!isMe) {
        final convIndex = conversations.indexWhere((c) => c.conversationId == conversationId);
        if (convIndex != -1) {
          final currentChat = conversations[convIndex];
          // Only increment if user is NOT actively viewing this conversation in an open chat UI
          final shouldIncrement = !isChatOpen.value || currentConversationId.value != conversationId;
          
          final lastMessageText = text.trim().isNotEmpty ? text : 'Image';
          
          conversations[convIndex] = currentChat.copyWith(
            subtitle: lastMessageText,
            time: 'Now',
            unreadCount: shouldIncrement ? (currentChat.unreadCount + 1) : currentChat.unreadCount,
          );
          
          // Move conversation to top
          if (convIndex > 0) {
            final item = conversations.removeAt(convIndex);
            conversations.insert(0, item);
          }
        } else {
          // New conversation not in list yet, refresh
          loadConversations();
        }
      }
    });
  }

  @override
  void onClose() {
    // Controller is permanent, onClose is not called on navigation
    // Socket connection is managed by SocketService singleton
    _tokenWorker?.dispose();
    super.onClose();
  }

  // Connect to socket
  void connectSocket() {
    _socketService.connect();
  }

  // Load current user's photo
  void loadCurrentUserPhoto() {
    currentUserPhotoUrl.value = AuthService.to.userPhotoUrl.value ?? '';
  }

  // Load user's conversations from backend API
  void loadConversations() {
    final userId = currentUserId;
    if (userId == null) {
      clearUserData();
      return;
    }

    // Clear existing data to ensure fresh start for new user
    if (conversations.isNotEmpty || messages.isNotEmpty) {
      print('📱 Clearing old data before loading for user: $userId');
      conversations.clear();
      messages.clear();
      currentConversationId.value = '';
    }

    isLoading.value = true;

    // Fetch conversations from backend API
    _fetchConversationsFromApi();
  }

  Future<void> refreshConversations() async {
    if (currentUserId == null) return;
    if (_isRefreshing) {
      print('📱 Already refreshing, skipping duplicate call');
      return;
    }
    _isRefreshing = true;
    isLoading.value = true;
    try {
      await _fetchConversationsFromApi();
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _fetchConversationsFromApi() async {
    try {
      final token = AuthService.to.accessToken.value;
      print('📱 Fetching conversations... Token: ${token.isNotEmpty ? 'present' : 'missing'}');
      if (token.isEmpty) {
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/messages/conversations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📱 Conversations response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final List<dynamic> conversationsData = data['conversations'] ?? [];
        print('📱 Found ${conversationsData.length} conversations from API');
        print('📱 Response body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');

        final existingUnreadCounts = <String, int>{
          for (final c in conversations) c.conversationId: c.unreadCount,
        };

        conversations.clear();
        print('📱 Cleared conversations, adding ${conversationsData.length} from API');
        
        for (var conv in conversationsData) {
          print('📱 Processing conversation: ${conv['conversationId']}');
          final socketConv = SocketConversation.fromJson(conv);
          
          // Extract other user's name and photo from nested seller/buyer objects
          String otherUserName = 'User';
          String? otherUserPhoto;
          final currentUserIdStr = currentUserId;
          
          print('📱 Current user: $currentUserIdStr, Seller: ${socketConv.sellerId}, Buyer: ${socketConv.buyerId}');
          
          if (socketConv.sellerId == currentUserIdStr) {
            // Current user is seller, show buyer's info
            if (conv['buyer'] is Map) {
              otherUserName = conv['buyer']['name'] ?? 'User';
              otherUserPhoto = conv['buyer']['photoUrl'];
              print('📱 Using buyer name: $otherUserName, photo: $otherUserPhoto');
            }
          } else {
            // Current user is buyer, show seller's info
            if (conv['seller'] is Map) {
              otherUserName = conv['seller']['name'] ?? 'User';
              otherUserPhoto = conv['seller']['photoUrl'];
              print('📱 Using seller name: $otherUserName, photo: $otherUserPhoto');
            }
          }
          
          // Fallback to API call if nested objects don't have the data
          if (otherUserName == 'User') {
            print('📱 Falling back to _fetchUserName');
            otherUserName = await _fetchUserName(socketConv.sellerId == currentUserIdStr
                ? socketConv.buyerId
                : socketConv.sellerId);
          }

          final mergedUnreadCount = max(
            socketConv.unreadCount,
            existingUnreadCounts[socketConv.conversationId] ?? 0,
          );

          final chatUser = ChatUser.fromConversation(
            id: socketConv.id,
            conversationId: socketConv.conversationId,
            otherUserName: otherUserName,
            lastMessage: socketConv.lastMessage ?? '',
            listingTitle: socketConv.listingTitle ?? 'Listing',
            listingPrice: socketConv.listingPrice,
            lastMessageTime: socketConv.lastMessageTime,
            unreadCount: mergedUnreadCount,
            listingId: socketConv.listingId,
            sellerId: socketConv.sellerId,
            buyerId: socketConv.buyerId,
            photoUrl: otherUserPhoto,
            listingImage: socketConv.listingImages != null && socketConv.listingImages!.isNotEmpty
                ? socketConv.listingImages![0]
                : null,
          );
          
          // Check for duplicate before adding
          final existingIndex = conversations.indexWhere((c) => c.conversationId == chatUser.conversationId);
          if (existingIndex == -1) {
            conversations.add(chatUser);
            print('📱 Added conversation: ${chatUser.name} - ${chatUser.conversationId}');
          } else {
            print('📱 Conversation already exists: ${chatUser.conversationId}, skipping');
          }
        }

        // Sort by time (newest first)
        conversations.sort((a, b) => b.time.compareTo(a.time));
        print('📱 Total conversations in list: ${conversations.length}');
      } else {
        print('📱 Failed to fetch conversations: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('📱 Error loading conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _fetchUserName(String userId) async {
    try {
      final token = AuthService.to.accessToken.value;
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['name'] ?? data['email'] ?? 'User';
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
    return 'User';
  }

  // Select a conversation
  void selectChat(int index) {
    if (index >= conversations.length) return;

    selectedChatIndex.value = index;
    final selectedChat = conversations[index];
    otherUserId.value = selectedChat.sellerId == currentUserId
        ? selectedChat.buyerId
        : selectedChat.sellerId;
    otherUserName.value = selectedChat.name;

    // Join the conversation room
    _socketService.joinConversation(selectedChat.conversationId);

    // Load messages for this conversation
    loadMessages(selectedChat.conversationId);
  }

  // Load messages for a conversation
  void loadMessages(String conversationId, {bool forceReload = false}) {
    // If already on the same conversation and not forcing, keep existing messages
    if (!forceReload && currentConversationId.value == conversationId && messages.isNotEmpty) {
      return;
    }

    // If switching conversations (or forcing reload), clear in-memory list so we don't mix threads
    if (forceReload || currentConversationId.value != conversationId) {
      messages.clear();
    }

    isLoadingMessages.value = true;
    currentConversationId.value = conversationId;

    // Clear unread count locally
    final convIndex = conversations.indexWhere((c) => c.conversationId == conversationId);
    if (convIndex != -1) {
      conversations[convIndex] = conversations[convIndex].copyWith(unreadCount: 0);
    }
    
    // Mark as read in backend
    markMessagesAsRead(conversationId);

    // Register socket listener for this conversation (replace any existing listener)
    _socketService.onMessage(conversationId, (data) async {
      try {
        final socketMessage = SocketMessage.fromJson(data);
        final currentUserIdStr = currentUserId ?? '';
        final isMeMessage = socketMessage.senderId == currentUserIdStr;
        print('📨 Socket message: senderId=${socketMessage.senderId} (type: ${socketMessage.senderId.runtimeType}), currentUserId=$currentUserIdStr (type: ${currentUserIdStr.runtimeType}), isMe=$isMeMessage');

        final hasImageIncoming = data['imageBase64'] != null || data['imageUrl'] != null;

        // Check if message already exists (avoid duplicates from socket retries)
        final existingByIdIndex = messages.indexWhere((m) => m.id == socketMessage.id);

        print('📨 Socket message data keys: ${data.keys.toList()}');
        print('📨 imageBase64 present: ${data['imageBase64'] != null}');
        if (data['imageBase64'] != null) {
          print('📨 imageBase64 length: ${data['imageBase64'].toString().length}');
        }

        // Handle base64 image if present
        String? imagePath;
        if (data['imageBase64'] != null) {
          try {
            final bytes = base64Decode(data['imageBase64']);
            print('📨 Decoded ${bytes.length} bytes from base64');
            final appDir = await getApplicationDocumentsDirectory();
            final chatImagesDir = Directory('${appDir.path}/chat_images');
            if (!await chatImagesDir.exists()) {
              await chatImagesDir.create(recursive: true);
            }
            final file = File('${chatImagesDir.path}/${socketMessage.id}.png');
            await file.writeAsBytes(bytes);
            imagePath = file.path;
            print('📨 Saved received image to persistent storage: $imagePath');
          } catch (e, stackTrace) {
            print('📨 Error saving received image: $e');
            print('📨 Stack trace: $stackTrace');
          }
        } else if (data['imageUrl'] != null) {
          imagePath = data['imageUrl'];
          print('📨 Using imageUrl: $imagePath');
        }

        // Update new message list
        if (existingByIdIndex != -1) {
          _removeOptimisticDuplicate(
            serverId: socketMessage.id,
            text: socketMessage.text,
            senderId: socketMessage.senderId,
            serverTimestamp: socketMessage.timestamp,
            hasImage: hasImageIncoming,
          );
          return;
        }

        final optimisticIndex = _findOptimisticMatchIndex(
          serverId: socketMessage.id,
          text: socketMessage.text,
          senderId: socketMessage.senderId,
          serverTimestamp: socketMessage.timestamp,
          hasImage: hasImageIncoming,
        );

        if (optimisticIndex != -1) {
          messages[optimisticIndex] = ChatMessage.fromMessage(
            id: socketMessage.id,
            text: socketMessage.text,
            timestamp: socketMessage.timestamp,
            isMe: isMeMessage,
            isRead: socketMessage.isRead,
            senderId: socketMessage.senderId,
            imagePath: imagePath,
            imageUrl: imagePath,
          );
        } else {
          messages.add(ChatMessage.fromMessage(
            id: socketMessage.id,
            text: socketMessage.text,
            timestamp: socketMessage.timestamp,
            isMe: isMeMessage,
            isRead: socketMessage.isRead,
            senderId: socketMessage.senderId,
            imagePath: imagePath,
            imageUrl: imagePath,
          ));
        }

        // Update conversation list item subtitle
        final convIndex = conversations.indexWhere((c) => c.conversationId == conversationId);
        if (convIndex != -1) {
          final lastMessageText = socketMessage.text.trim().isNotEmpty ? socketMessage.text : 'Image';
          final currentChat = conversations[convIndex];
          
          // Increment unread count if message is not from me and its not the current active chat
          final shouldIncrementUnread = !isMeMessage && currentConversationId.value != conversationId;
          
          conversations[convIndex] = currentChat.copyWith(
            subtitle: lastMessageText,
            time: 'Now',
            unreadCount: shouldIncrementUnread ? (currentChat.unreadCount + 1) : currentChat.unreadCount,
          );
          
          // Move conversation to top if not already there
          if (convIndex > 0) {
            final item = conversations.removeAt(convIndex);
            conversations.insert(0, item);
          }
        }

      // Save messages to local storage
      await _storageService.saveMessages(conversationId, messages.toList());
      } catch (e) {
        print('📨 Error in socket message handler: $e');
      }
    });

    // Load from local storage first
    _loadMessagesFromStorage(conversationId);

    // Then fetch from API and merge
    _fetchMessagesFromApi(conversationId);
  }

  // Get total unread messages count
  int get totalUnreadCount => conversations.fold(0, (sum, chat) => sum + chat.unreadCount);

  // Load messages from local storage and recalculate isMe
  Future<void> _loadMessagesFromStorage(String conversationId) async {
    final savedMessages = await _storageService.loadMessages(conversationId);
    if (savedMessages.isNotEmpty) {
      // Recalculate isMe for each message based on current user
      final currentUserIdStr = currentUserId ?? '';
      print('📥 Loading ${savedMessages.length} messages from storage. Current user: $currentUserIdStr');
      
      final recalculatedMessages = savedMessages.map((m) {
        final newIsMe = m.senderId == currentUserIdStr;
        print('📥 Message "${m.text}": senderId=${m.senderId}, currentUserId=$currentUserIdStr, oldIsMe=${m.isMe}, newIsMe=$newIsMe');
        return m.copyWithRecalculatedIsMe(currentUserIdStr);
      }).toList();
      
      messages.assignAll(recalculatedMessages);
      print('📥 Loaded and recalculated ${savedMessages.length} messages');
    }
  }

  Future<void> _fetchMessagesFromApi(String conversationId) async {
    try {
      final token = AuthService.to.accessToken.value;
      final currentUserIdStr = currentUserId;
      print('📥 Fetching messages for conversation: $conversationId, currentUserId: $currentUserIdStr');

      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/messages/$conversationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Received response ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> messagesData = data['messages'] ?? [];
        print('📥 Found ${messagesData.length} messages from API');

        // Merge with existing messages instead of clearing
        final existingIds = messages.map((m) => m.id).toSet();
        for (var msg in messagesData) {
          try {
            final socketMessage = SocketMessage.fromJson(msg);
            final currentUserIdStr = currentUserId ?? '';
            final isMeMessage = socketMessage.senderId == currentUserIdStr;
            print('📥 Processing message: id=${socketMessage.id}, senderId=${socketMessage.senderId} (type: ${socketMessage.senderId.runtimeType}), currentUserId=$currentUserIdStr (type: ${currentUserIdStr.runtimeType}), isMe=$isMeMessage');

            final dynamic rawImage = msg['imageUrl'] ?? msg['imagePath'];
            final String? imageUrlFromApi = rawImage != null && rawImage.toString().isNotEmpty
                ? (rawImage.toString().startsWith('/') ? rawImage.toString() : '/${rawImage.toString()}')
                : null;

            final bool hasText = socketMessage.text.trim().isNotEmpty;
            final bool hasImage = imageUrlFromApi != null && imageUrlFromApi.isNotEmpty;
            if (!hasText && !hasImage) {
              continue;
            }
            if (existingIds.contains(socketMessage.id)) {
              _removeOptimisticDuplicate(
                serverId: socketMessage.id,
                text: socketMessage.text,
                senderId: socketMessage.senderId,
                serverTimestamp: socketMessage.timestamp,
                hasImage: hasImage,
              );
              continue;
            } else {
              final chatMessage = ChatMessage.fromMessage(
                id: socketMessage.id,
                text: socketMessage.text,
                timestamp: socketMessage.timestamp,
                isMe: isMeMessage,
                isRead: socketMessage.isRead,
                senderId: socketMessage.senderId,
                imagePath: null,
                imageUrl: imageUrlFromApi,
              );
              messages.add(chatMessage);
              existingIds.add(socketMessage.id);
              print('📥 Added message: ${chatMessage.text}, isMe: ${chatMessage.isMe}, senderId: ${chatMessage.senderId}');
            }
          } catch (e) {
            print('📥 Error processing message: $e, msg: $msg');
          }
        }
        print('📥 Total messages in state: ${messages.length}');

        // Sort by timestamp
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        // Save to local storage
        await _storageService.saveMessages(conversationId, messages.toList());
      }
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {
      isLoadingMessages.value = false;
    }
  }

  // Send a message
  Future<bool> sendMessage(String text) async {
    if (currentUserId == null) {
      Get.snackbar('Error', 'Please login to send messages');
      return false;
    }

    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    // If no conversation ID, create one first
    if (currentConversationId.value.isEmpty) {
      print('No conversation ID, creating one...');
      final created = await createOrGetConversation();
      if (!created) {
        Get.snackbar('Error', 'Failed to create conversation');
        return false;
      }
    }

    // Optimistic update - show message immediately
    final optimisticMessage = ChatMessage.fromMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      timestamp: DateTime.now(),
      isMe: true,
      isRead: false,
      senderId: currentUserId!,
    );
    messages.add(optimisticMessage);

    // Persist immediately so the sender doesn't lose messages on app restart
    try {
      if (currentConversationId.value.isNotEmpty) {
        await _storageService.saveMessages(
          currentConversationId.value,
          messages.toList(),
        );
      }
    } catch (e) {
      print('Error saving optimistic message: $e');
    }

    try {
      // Send via socket
      _socketService.sendMessage(
        conversationId: currentConversationId.value,
        text: trimmed,
        listingId: listingIdValue.value,
      );

      messageText.value = '';
      return true;
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar('Error', 'Failed to send message');
      // Remove optimistic message on error
      messages.remove(optimisticMessage);
      return false;
    }
  }

  // Send image message
  Future<void> sendImageMessage(String imagePath, String? caption) async {
    print('📤 Sending image: $imagePath with caption: $caption');
    
    if (currentConversationId.value.isEmpty) {
      print('No conversation ID, creating one...');
      final created = await createOrGetConversation();
      if (!created) {
        Get.snackbar('Error', 'Failed to create conversation');
        return;
      }
    }

    // Copy image to persistent storage (app documents directory)
    String persistentImagePath;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final chatImagesDir = Directory('${appDir.path}/chat_images');
      if (!await chatImagesDir.exists()) {
        await chatImagesDir.create(recursive: true);
      }
      final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.png';
      final persistentFile = File('${chatImagesDir.path}/$fileName');
      await File(imagePath).copy(persistentFile.path);
      persistentImagePath = persistentFile.path;
      print('📤 Image copied to persistent storage: $persistentImagePath');
    } catch (e) {
      print('❌ Error copying image to persistent storage: $e');
      persistentImagePath = imagePath; // Fallback to original path
    }

    // Create optimistic message with persistent image path
    final tempId = 'temp_img_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticMessage = ChatMessage.fromMessage(
      id: tempId,
      text: caption ?? '',
      timestamp: DateTime.now(),
      isMe: true,
      isRead: false,
      senderId: currentUserId!,
      imagePath: persistentImagePath,
      imageUrl: null,
    );
    messages.add(optimisticMessage);

    try {
      // Read image and convert to base64
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      print('📤 Sending image via socket, size: ${bytes.length} bytes');
      
      // Send message with base64 image via socket
      _socketService.sendMessage(
        conversationId: currentConversationId.value,
        text: caption ?? '',
        listingId: listingIdValue.value,
        imageBase64: base64Image,
      );
    } catch (e) {
      print('❌ Error sending image: $e');
      Get.snackbar('Error', 'Failed to send image');
    }

    // Persist messages
    try {
      if (currentConversationId.value.isNotEmpty) {
        await _storageService.saveMessages(
          currentConversationId.value,
          messages.toList(),
        );
      }
    } catch (e) {
      print('Error saving image message: $e');
    }
  }

  // Create or get conversation before sending first message
  Future<bool> createOrGetConversation() async {
    if (currentUserId == null) return false;

    try {
      final token = AuthService.to.accessToken.value;
      final sellerId = int.tryParse(otherUserId.value) ?? 0;
      final buyerId = int.tryParse(currentUserId!) ?? 0;

      if (sellerId == 0 || buyerId == 0) {
        print('Invalid IDs: sellerId=$sellerId, buyerId=$buyerId');
        return false;
      }

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/messages/create-conversation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'listingId': listingIdValue.value,
          'sellerId': sellerId,
          'buyerId': buyerId,
          'listingTitle': listingTitleValue.value.isNotEmpty ? listingTitleValue.value : null,
          'listingPrice': listingPriceValue.value,
          'listingImages': listingImagesValue.toList(),
        }),
      );

      print('Create conversation response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final conversation = data['conversation'];
        currentConversationId.value = conversation['conversationId'];
        _socketService.joinConversation(currentConversationId.value);
        
        // Add the new conversation to the list so it appears in Messages screen
        // Determine the other user's name based on whether current user is buyer or seller
        final currentUserIsBuyer = conversation['buyerId'].toString() == currentUserId;
        String otherUserName;
        if (currentUserIsBuyer) {
          // Current user is buyer, show seller's name
          otherUserName = conversation['seller']?['name'] ?? 'Seller';
        } else {
          // Current user is seller, show buyer's name
          otherUserName = conversation['buyer']?['name'] ?? 'Buyer';
        }
        
        final newConversation = ChatUser.fromConversation(
          id: conversation['id'].toString(),
          conversationId: conversation['conversationId'],
          otherUserName: otherUserName,
          lastMessage: conversation['lastMessage'] ?? '',
          listingTitle: conversation['listingTitle'] ?? listingTitleValue.value,
          listingPrice: conversation['listingPrice'] != null 
              ? double.tryParse(conversation['listingPrice'].toString()) 
              : listingPriceValue.value,
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
          listingId: conversation['listingId'] ?? listingIdValue.value,
          sellerId: conversation['sellerId'].toString(),
          buyerId: conversation['buyerId'].toString(),
          listingImage: conversation['listingImages'] != null 
              ? (conversation['listingImages'] is List && conversation['listingImages'].isNotEmpty
                  ? conversation['listingImages'][0].toString()
                  : null)
              : (listingImagesValue.isNotEmpty ? listingImagesValue[0] : null),
        );
        
        // Check if conversation already exists in list
        final existingIndex = conversations.indexWhere(
          (c) => c.conversationId == newConversation.conversationId,
        );
        if (existingIndex == -1) {
          conversations.insert(0, newConversation);
          print('📱 Added new conversation to list: ${newConversation.conversationId}');
        }
        
        return true;
      }
    } catch (e) {
      print('Error creating conversation: $e');
    }
    return false;
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      final token = AuthService.to.accessToken.value;
      await http.post(
        Uri.parse('${ApiService.baseUrl}/messages/$conversationId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // Clear all chat data when user logs out or changes
  void clearUserData() {
    print('🧹 Clearing MessagesController user data');
    messages.clear();
    conversations.clear();
    currentConversationId.value = '';
    otherUserId.value = '';
    otherUserName.value = '';
    otherUserPhotoUrl.value = '';
    currentUserPhotoUrl.value = '';
    selectedChatIndex.value = 0;
    listingIdValue.value = 0;
    listingTitleValue.value = '';
    listingPriceValue.value = null;
    listingImagesValue.clear();
    // Clear all stored messages for all conversations
    _storageService.clearAllMessages();
  }
}
