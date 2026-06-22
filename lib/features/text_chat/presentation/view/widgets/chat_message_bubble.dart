import 'package:flutter/material.dart';

class ChatMessage {
  final String? text;
  final bool isUser;
  final DateTime timestamp;
  final Stream<String>? stream;
  ChatMessage({
    this.text,
    required this.isUser,
    required this.timestamp,
    this.stream,
  });
}

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showVoiceLabel;
  /// Called whenever a new streaming chunk arrives, so the parent
  /// can scroll the list to the bottom as the bubble grows.
  final VoidCallback? onStreamChunk;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.showVoiceLabel = false,
    this.onStreamChunk,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) const _AiAvatar(),
          Flexible(
            child: _BubbleContent(
              message: message,
              showVoiceLabel: showVoiceLabel,
              onStreamChunk: onStreamChunk,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiAvatar extends StatelessWidget {
  const _AiAvatar();
  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 32,
    margin: const EdgeInsets.only(right: 8, top: 4),
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
    ),
    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
  );
}

class _BubbleContent extends StatefulWidget {
  final ChatMessage message;
  final bool showVoiceLabel;
  final VoidCallback? onStreamChunk;

  const _BubbleContent({
    required this.message,
    required this.showVoiceLabel,
    this.onStreamChunk,
  });

  @override
  State<_BubbleContent> createState() => _BubbleContentState();
}

class _BubbleContentState extends State<_BubbleContent> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: widget.message.isUser
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6C63FF), Color(0xFF5346E2)],
              )
            : null,
        color: widget.message.isUser ? null : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(widget.message.isUser ? 20 : 4),
          bottomRight: Radius.circular(widget.message.isUser ? 4 : 20),
        ),
        border: widget.message.isUser
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.message.stream != null)
            StreamBuilder<String>(
              stream: widget.message.stream,
              builder: (context, snapshot) {
                final isDone =
                    snapshot.connectionState == ConnectionState.done;
                final text = snapshot.data ?? widget.message.text ?? '';

                // Notify parent to scroll after the frame renders the new text
                if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onStreamChunk?.call();
                  });
                }

                return Text(
                  isDone ? text : '$text▋',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 16,
                    height: 1.5,
                  ),
                );
              },
            )
          else
            Text(
              widget.message.text!,
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 16,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}
