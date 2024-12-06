import 'dart:async';

import 'package:flutter/material.dart';


import '../models/models.dart';
import '/display/display.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _botMessages = const [
  // Anxiety
  Message(
    message: "Tell me more about what is causing your anxiety.I'm here to understand and help.",
    isFromUser: false,
  ),
  Message(
    message: "To cope with anxiety, try practicing deep breathing exercises, mindfulness meditation, or physical activities like walking or yoga. These can help calm your mind and reduce stress.",
    isFromUser: false,
  ),
  Message(
    message: "As stated previously, anxiety can be further dealt with by identifying and challenging negative thoughts, maintaining a healthy sleep routine, and seeking support from trusted individuals or professionals.",
    isFromUser: false,
  ),
  
  // Relationship Issues
  Message(
    message: "Can you share more about the challenges you're facing in your relationships? Are they related to communication, trust, or understanding each other's needs?",
    isFromUser: false,
  ),
  Message(
    message: "To improve relationships, focus on open communication, actively listening to the other person, and expressing your feelings honestly and respectfully. Consider setting aside quality time to reconnect.",
    isFromUser: false,
  ),
  Message(
    message: "As stated previously, resolving relationship issues also involves setting healthy boundaries, being empathetic, and seeking counseling if needed. Relationships thrive when both parties feel valued and heard.",
    isFromUser: false,
  ),
  
  // Depression
  Message(
    message: "Could you tell me more about what you're feeling? Understanding what might be triggering your depression is a good first step toward addressing it.",
    isFromUser: false,
  ),
  Message(
    message: "To manage depression, try setting small, achievable goals, engaging in activities that once brought you joy, and prioritizing self-care. Reach out to a trusted friend or therapist for support.",
    isFromUser: false,
  ),
  Message(
    message: "As stated previously, coping with depression may also include maintaining a regular sleep schedule, eating nutritious meals, and seeking professional help if the feelings persist. Remember, recovery is a process.",
    isFromUser: false,
  ),
  
  // Stress
  Message(
    message: "What aspects of your life are currently causing you the most stress? Understanding the sources can help in finding effective ways to manage them.",
    isFromUser: false,
  ),
  Message(
    message: "To manage stress, try creating a to-do list to prioritize tasks, practicing relaxation techniques like progressive muscle relaxation, and taking breaks to recharge your energy.",
    isFromUser: false,
  ),
  Message(
    message: "As stated previously, stress can also be reduced by maintaining a work-life balance, setting realistic expectations for yourself, and seeking support when you feel overwhelmed.",
    isFromUser: false,
  ),
  
  // Family Issues
  Message(
    message: "Could you share more about the family issues you're experiencing? Are they related to conflicts, misunderstandings, or other dynamics?",
    isFromUser: false,
  ),
  Message(
    message: "To address family issues, focus on clear and empathetic communication, finding common ground, and being willing to compromise. Family therapy can also provide a neutral space for resolving conflicts.",
    isFromUser: false,
  ),
  Message(
    message: "As stated previously, family issues can also be worked through by showing appreciation for each other's efforts, setting healthy boundaries, and building mutual respect over time.",
    isFromUser: false,
  ),
];


  // Stores all chat messages (both user and bot)
  final List<Message> _messages = [];

  int _botMessageIndex = 0;

  bool _isBotTyping = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  //Meant to fetch user's name
  void _fetchUser() {
    setState(() {
      _messages.add(const Message(
          message: "Hello John,\nI am Faraja, your mental health support bot. How can I assist you today? I'm here to help you navigate any challenges or concerns you may have.",
  isFromUser: false,));
    });
  }

  void _scrollToBottom() {
    if(_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    String userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add(Message(message: userMessage, isFromUser: true));
      _isBotTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    if (_botMessageIndex < _botMessages.length) {
      Timer(const Duration(seconds: 3), () {
        setState(() {
          _messages.add(_botMessages[_botMessageIndex]);
          _botMessageIndex++;
          _isBotTyping = false;
        });
        _scrollToBottom();
      });
    } else {
      setState(() {
        _isBotTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Chat with Akili Doctor 🤖",
              style: theme.textTheme.titleLarge,
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isFromUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: message.isFromUser
                            ? MainAxisAlignment.end 
                            : MainAxisAlignment
                                .start, 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show icon for bot messages
                          if (!message.isFromUser)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                CustomIcons.robot,   
                                size: 30,
                                color: theme.colorScheme.primary,                             
                              ),
                            ),
                          // Message container
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: message.isFromUser
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Flexible(
                              child: Text(
                                message.message,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: message.isFromUser
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onPrimaryContainer,
                                ),
                                
                              ),
                            ),
                          ),
                          // Show icon for user messages
                          if (message.isFromUser)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.person, 
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              child: Row(
                children: [
                  if (!_isBotTyping) ...[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Chat with Akili Doctor...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ] else
                    Expanded(
                      child: Center(
                        child: FadeTransition(
                          opacity: _animationController,
                          child: Text(
                            "Akili Doctor is typing...",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
