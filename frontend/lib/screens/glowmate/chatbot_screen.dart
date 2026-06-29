import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/api_service.dart';
import '../../constants.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {

  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;

  // ==========================================================
  // SEND MESSAGE
  // ==========================================================

  Future<void> sendMessage() async {

    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();

    setState(() {
      _messages.add({
        "role": "user",
        "message": userMessage,
      });

      _isLoading = true;
    });

    _controller.clear();

    try {

      final reply = await ApiService.sendChatMessage(userMessage);

      setState(() {
        _messages.add({
          "role": "bot",
          "message": reply,
        });
      });

    } catch (e) {

      setState(() {
        _messages.add({
          "role": "bot",
          "message": "Sorry, something went wrong. Please try again.",
        });
      });

    } finally {

      setState(() {
        _isLoading = false;
      });
    }
  }

  // ==========================================================
  // MESSAGE BUBBLE
  // ==========================================================

  Widget _buildMessageBubble(Map<String, String> message) {

    final bool isUser = message["role"] == "user";

    return Align(

      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(

        margin: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),

        constraints: const BoxConstraints(maxWidth: 280),

        decoration: BoxDecoration(

          color: isUser
              ? AppColors.primary.withOpacity(.15)
              : Colors.grey.shade200,

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),

        child: Text(
          message["message"] ?? "",
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.4,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // TYPING INDICATOR
  // ==========================================================

  Widget _buildTypingIndicator() {

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 14,
      ),

      child: Row(

        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            "GlowMate is typing...",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textLight,
            ),
          )
        ],
      ),
    );
  }

  // ==========================================================
  // INPUT AREA
  // ==========================================================

  Widget _buildInputArea() {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ],
      ),

      child: Row(

        children: [

          Expanded(

            child: TextField(

              controller: _controller,

              style: GoogleFonts.poppins(),

              decoration: InputDecoration(

                hintText: "Ask about your skin...",

                hintStyle: GoogleFonts.poppins(
                  color: AppColors.textLight,
                ),

                filled: true,
                fillColor: Colors.grey.shade100,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),

              onSubmitted: (value) {
                sendMessage();
              },
            ),
          ),

          const SizedBox(width: 8),

          Container(

            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),

            child: IconButton(

              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),

              onPressed: sendMessage,
            ),
          )
        ],
      ),
    );
  }

  // ==========================================================
  // MAIN UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.white,

        title: Text(
          "GlowMate AI",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child: ListView.builder(

              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),

              itemCount: _messages.length,

              itemBuilder: (context, index) {

                return _buildMessageBubble(_messages[index]);

              },
            ),
          ),

          if (_isLoading) _buildTypingIndicator(),

          _buildInputArea(),
        ],
      ),
    );
  }
}
