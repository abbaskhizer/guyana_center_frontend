import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guyana_center_frontend/modal/message.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';

class FirebaseMessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => AuthService.to.userId?.toString();

  // Generate conversation ID from two user IDs (sorted to ensure consistency)
  String getConversationId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  // Create or get conversation between two users for a specific listing
  Future<Conversation?> createOrGetConversation({
    required int listingId,
    required String sellerId,
    required String buyerId,
    String? listingTitle,
    double? listingPrice,
  }) async {
    try {
      final conversationId = getConversationId(sellerId, buyerId);
      print('🔍 Looking for conversation: $conversationId');

      // Check if conversation exists
      final docRef = _firestore.collection('conversations').doc(conversationId);
      final doc = await docRef.get();
      print('📄 Document exists: ${doc.exists}');

      if (doc.exists) {
        // Return existing conversation
        final data = doc.data();
        if (data != null) {
          print('✅ Returning existing conversation');
          return Conversation(
            id: doc.id,
            conversationId: conversationId,
            listingId: data['listingId'] ?? listingId,
            sellerId: data['sellerId'] ?? sellerId,
            buyerId: data['buyerId'] ?? buyerId,
            listingTitle: data['listingTitle'] ?? listingTitle,
            listingPrice: data['listingPrice'] != null
                ? double.tryParse(data['listingPrice'].toString())
                : listingPrice,
            lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ??
                DateTime.now(),
            lastMessage: data['lastMessage'],
            unreadCount: data['unreadCount'] ?? 0,
          );
        }
      }

      // Create new conversation
      print('✏️ Creating new conversation...');
      final conversation = Conversation(
        id: doc.id,
        conversationId: conversationId,
        listingId: listingId,
        sellerId: sellerId,
        buyerId: buyerId,
        listingTitle: listingTitle,
        listingPrice: listingPrice,
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
      );

      await docRef.set(conversation.toJson());
      print('✅ Conversation created successfully');

      return conversation;
    } catch (e, stackTrace) {
      print('❌ Error creating conversation: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Send a message
  Future<bool> sendMessage({
    required String conversationId,
    required String text,
    required int listingId,
    String? listingTitle,
    double? listingPrice,
  }) async {
    try {
      if (currentUserId == null) {
        print('❌ No current user');
        return false;
      }

      print('💬 Sending message to conversation: $conversationId');

      final messagesRef =
          _firestore.collection('conversations').doc(conversationId).collection('messages');

      // Create message
      final message = Message(
        id: '',
        conversationId: conversationId,
        senderId: currentUserId!,
        receiverId: '', // Will be determined by conversation
        text: text,
        timestamp: DateTime.now(),
        isRead: false,
      );

      // Add message to Firestore
      final docRef = await messagesRef.add(message.toJson());
      print('✅ Message added with ID: ${docRef.id}');

      // Update conversation's last message
      final conversationRef = _firestore.collection('conversations').doc(conversationId);
      await conversationRef.update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        if (listingTitle != null) 'listingTitle': listingTitle,
        if (listingPrice != null) 'listingPrice': listingPrice.toString(),
        if (listingId != 0) 'listingId': listingId,
      });
      print('✅ Conversation updated');

      return true;
    } catch (e, stackTrace) {
      print('❌ Error sending message: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  // Get messages stream for a conversation
  Stream<List<Message>> getMessagesStream(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList();
    });
  }

  // Get user's conversations stream
  Stream<List<Conversation>> getUserConversationsStream(String userId) {
    return _firestore
        .collection('conversations')
        .where('buyerId', isEqualTo: userId)
        .snapshots()
        .asyncMap((buyerSnap) async {
      // Also get conversations where user is seller
      final sellerSnap = await _firestore
          .collection('conversations')
          .where('sellerId', isEqualTo: userId)
          .get();

      // Combine both lists
      final allConversations = [
        ...buyerSnap.docs.map((doc) {
          final data = doc.data();
          return Conversation(
            id: doc.id,
            conversationId: doc.id,
            listingId: data['listingId'] ?? 0,
            sellerId: data['sellerId'] ?? '',
            buyerId: data['buyerId'] ?? '',
            listingTitle: data['listingTitle'],
            listingPrice: data['listingPrice'] != null
                ? double.tryParse(data['listingPrice'].toString())
                : null,
            lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ??
                DateTime.now(),
            lastMessage: data['lastMessage'],
            unreadCount: data['unreadCount'] ?? 0,
          );
        }),
        ...sellerSnap.docs.map((doc) {
          final data = doc.data();
          return Conversation(
            id: doc.id,
            conversationId: doc.id,
            listingId: data['listingId'] ?? 0,
            sellerId: data['sellerId'] ?? '',
            buyerId: data['buyerId'] ?? '',
            listingTitle: data['listingTitle'],
            listingPrice: data['listingPrice'] != null
                ? double.tryParse(data['listingPrice'].toString())
                : null,
            lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate() ??
                DateTime.now(),
            lastMessage: data['lastMessage'],
            unreadCount: data['unreadCount'] ?? 0,
          );
        }),
      ];

      // Sort by last message time (descending)
      allConversations.sort((a, b) =>
          b.lastMessageTime.compareTo(a.lastMessageTime));

      return allConversations;
    });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      if (currentUserId == null) return;

      final messagesRef =
          _firestore.collection('conversations').doc(conversationId).collection('messages');

      // Get unread messages
      final unreadMessages = await messagesRef
          .where('receiverId', isEqualTo: currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      // Mark each as read
      final batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();

      // Update conversation unread count
      await _firestore.collection('conversations').doc(conversationId).update({
        'unreadCount': 0,
      });
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // Delete a message
  Future<bool> deleteMessage(String conversationId, String messageId) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .delete();

      return true;
    } catch (e) {
      print('Error deleting message: $e');
      return false;
    }
  }

  // Get user display name
  Future<String> getUserDisplayName(String userId) async {
    try {
      // Check if it's the current user
      if (userId == currentUserId) {
        return AuthService.to.userName.value ?? 'You';
      }

      // Fetch from users collection
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        return data?['name'] ?? data?['email'] ?? 'User';
      }

      return 'User';
    } catch (e) {
      print('Error getting user display name: $e');
      return 'User';
    }
  }

  // Get user photo URL
  Future<String> getUserPhotoUrl(String userId) async {
    try {
      // Check if it's the current user
      if (userId == currentUserId) {
        return AuthService.to.userPhotoUrl.value ?? '';
      }

      // Fetch from users collection
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        return data?['photoUrl'] ?? data?['photoURL'] ?? '';
      }

      return '';
    } catch (e) {
      print('Error getting user photo URL: $e');
      return '';
    }
  }

  // Get user email (fallback for display)
  Future<String> getUserEmail(String userId) async {
    try {
      if (userId == currentUserId) {
        return AuthService.to.userEmail.value ?? '';
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        return data?['email'] ?? '';
      }

      return '';
    } catch (e) {
      print('Error getting user email: $e');
      return '';
    }
  }

  // Check if user exists in Firebase Auth
  Future<bool> userExists(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }
}
