import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyana_center_frontend/controller/message_controller.dart';
import 'package:guyana_center_frontend/modal/chat_user.dart';
import 'package:guyana_center_frontend/services/auth_service.dart';
import 'package:guyana_center_frontend/services/api_services.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserPhotoUrl;
  final int listingId;
  final String listingTitle;
  final double? listingPrice;
  final List<String>? listingImages;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserPhotoUrl,
    required this.listingId,
    required this.listingTitle,
    this.listingPrice,
    this.listingImages,
  });

  @override
  Widget build(BuildContext context) {
    // Use Get.find to reuse existing controller, or create if not exists
    final controller = Get.put(MessagesController(), permanent: true);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isTablet = MediaQuery.of(context).size.width >= 768 &&
        MediaQuery.of(context).size.width < 1100;

    // Initialize the conversation
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.otherUserId.value = otherUserId;
      controller.otherUserName.value = otherUserName;
      controller.listingIdValue.value = listingId;
      controller.listingTitleValue.value = listingTitle;
      controller.listingPriceValue.value = listingPrice;

      // Set listing images
      if (listingImages != null) {
        controller.listingImagesValue.assignAll(listingImages ?? []);
      }

      // Set other user's photo URL if provided
      if (otherUserPhotoUrl != null && otherUserPhotoUrl!.isNotEmpty) {
        final fullPhotoUrl = otherUserPhotoUrl!.startsWith('http')
            ? otherUserPhotoUrl!
            : '${ApiService.baseUrl}${otherUserPhotoUrl!.startsWith('/') ? '' : '/'}$otherUserPhotoUrl';
        controller.otherUserPhotoUrl.value = fullPhotoUrl;
      }

      // If conversationId is empty, try to reuse existing one from the controller
      if (conversationId.isEmpty) {
        if (controller.currentConversationId.value.isNotEmpty) {
          // Reuse the existing conversation ID
          final existingId = controller.currentConversationId.value;
          print('Reusing existing conversation ID: $existingId');
          controller.loadMessages(existingId, forceReload: false);
          controller.markMessagesAsRead(existingId);
        } else {
          // No existing ID, create a new conversation
          print('Creating conversation for listing $listingId...');
          final created = await controller.createOrGetConversation();
          print('Conversation created: $created, ID: ${controller.currentConversationId.value}');
          if (created) {
            controller.loadMessages(controller.currentConversationId.value, forceReload: true);
            controller.markMessagesAsRead(controller.currentConversationId.value);
          } else {
            print('Failed to create conversation');
          }
        }
      } else {
        // Use provided conversationId
        controller.loadMessages(conversationId, forceReload: true);
        controller.markMessagesAsRead(conversationId);
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _ChatHeader(
              name: otherUserName,
              itemTitle: listingTitle,
              price: listingPrice,
              otherUserId: otherUserId,
              listingId: listingId,
              listingImages: listingImages,
            ),
            Expanded(child: _ChatBody(isTablet: isTablet)),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends GetView<MessagesController> {
  final String name;
  final String itemTitle;
  final double? price;
  final String otherUserId;
  final int listingId;
  final List<String>? listingImages;

  const _ChatHeader({
    required this.name,
    required this.itemTitle,
    this.price,
    required this.otherUserId,
    required this.listingId,
    this.listingImages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerColor =
        theme.dividerTheme.color ?? colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: dividerColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
              Obx(() {
                final photoUrl = controller.otherUserPhotoUrl.value;
                if (photoUrl.isNotEmpty) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    backgroundImage: NetworkImage(photoUrl),
                    onBackgroundImageError: (_, __) {},
                    child: null,
                  );
                }
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: dividerColor),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border.all(color: dividerColor),
                    ),
                    child: listingImages != null && listingImages!.isNotEmpty
                        ? Image.network(
                            listingImages![0].startsWith('http')
                                ? listingImages![0]
                                : '${ApiService.baseUrl}${listingImages![0]}',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.image_outlined,
                              size: 24,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          )
                        : Icon(
                            Icons.image_outlined,
                            size: 24,
                            color: colorScheme.onSurfaceVariant,
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (price != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '\$$price',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: const Color(0xFFDC2626),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(
                      '/listing-detail',
                      arguments: {'listingId': listingId},
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View Ad',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBody extends GetView<MessagesController> {
  final bool isTablet;

  const _ChatBody({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerColor =
        theme.dividerTheme.color ?? colorScheme.outlineVariant;

    return Container(
      color: colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: dividerColor),
            ),
            child: Text(
              'Today',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoadingMessages.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  );
                }

                if (controller.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No messages yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Say hello to get started!',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 18 : 16,
                    vertical: 8,
                  ),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[controller.messages.length - 1 - index];
                    return _MessageBubble(message: msg);
                  },
                );
              },
            ),
          ),
          const _MessageComposer(),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bubbleColor = message.isMe
        ? colorScheme.primary
        : theme.scaffoldBackgroundColor;
    final textColor = message.isMe
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            crossAxisAlignment:
                message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(16),
                  border: message.isMe
                      ? null
                      : Border.all(
                          color: theme.dividerTheme.color ??
                              colorScheme.outlineVariant,
                        ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.imageUrl != null && message.imageUrl!.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          message.imageUrl!.startsWith('http')
                              ? message.imageUrl!
                              : '${ApiService.baseUrl}${message.imageUrl}',
                          width: 200,
                          height: 150,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 200,
                              height: 150,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 150,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 50),
                              ),
                            );
                          },
                        ),
                      ),
                      if (message.text.isNotEmpty) const SizedBox(height: 8),
                    ] else if (message.imagePath != null && message.imagePath!.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(message.imagePath!),
                          width: 200,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (message.text.isNotEmpty) const SizedBox(height: 8),
                    ],
                    if (message.text.isNotEmpty)
                      Text(
                        message.text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          height: 1.4,
                          color: textColor,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.time,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 9,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (message.isMe) ...[
                    const SizedBox(width: 2),
                    Icon(
                      message.isRead
                          ? Icons.done_all
                          : Icons.done,
                      size: 12,
                      color: message.isRead
                          ? const Color(0xFF2196F3)
                          : colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageComposer extends StatefulWidget {
  const _MessageComposer();

  @override
  State<_MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<_MessageComposer> {
  late final TextEditingController inputController;
  late final MessagesController controller;
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MessagesController>();
    inputController = TextEditingController();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.grey),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(source: ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.grey),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(source: ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage({ImageSource? source}) async {
    try {
      XFile? image;
      if (source == ImageSource.camera) {
        image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1200,
          maxHeight: 1200,
        );
      } else {
        image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1200,
          maxHeight: 1200,
        );
      }

      if (image != null && mounted) {
        setState(() {
          _selectedImagePath = image!.path;
        });
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void _send() {
    final text = inputController.text.trim();
    final hasImage = _selectedImagePath != null;

    if (text.isEmpty && !hasImage) return;

    if (hasImage) {
      controller.sendImageMessage(_selectedImagePath!, text.isNotEmpty ? text : null);
    } else {
      controller.sendMessage(text);
    }

    inputController.clear();
    setState(() {
      _selectedImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerColor = colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedImagePath != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_selectedImagePath!),
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 92,
                          height: 92,
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Material(
                        color: Colors.black.withOpacity(0.6),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            setState(() {
                              _selectedImagePath = null;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                IconButton(
                  onPressed: _showImageSourceDialog,
                  icon: Icon(
                    Icons.attach_file_outlined,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: dividerColor),
                    ),
                    child: TextField(
                      controller: inputController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _send,
                    icon: Icon(
                      Icons.send,
                      size: 18,
                      color: colorScheme.onPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
