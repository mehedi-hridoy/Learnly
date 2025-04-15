import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';


class AIScreen extends StatefulWidget {
  const AIScreen({super.key});


  @override
  State<AIScreen> createState() => _AIScreenState();
}


class _AIScreenState extends State<AIScreen> {
  final TextEditingController _userInput = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  bool _isDarkMode = false;


  final String apiKey = "AIzaSyCyQLP7BkeMAj7mSOj1wBnZycXDelsB8A0";
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";


  final List<String> _motivationalQuotes = [
    "The successful warrior is the average man, with laser-like focus. — Bruce Lee",
    "Deep work is the ability to focus without distraction on a cognitively demanding task. — Cal Newport",
    "It's not that I'm so smart, it's just that I stay with problems longer. — Albert Einstein",
    "You will never reach your destination if you stop and throw stones at every dog that barks. — Winston Churchill",
    "Focus on the journey, not the destination. Joy is found not in finishing an activity but in doing it. — Greg Anderson",
    "Don't watch the clock; do what it does. Keep going. — Sam Levenson",
    "The best way to predict your future is to create it. — Abraham Lincoln",
    "Success is not final, failure is not fatal: It is the courage to continue that counts. — Winston Churchill",
    "Your mind is a powerful thing. When you fill it with positive thoughts, your life will start to change. — Unknown",
    "The difference between ordinary and extraordinary is that little extra. — Jimmy Johnson",
    "Start where you are. Use what you have. Do what you can. — Arthur Ashe",
    "The secret of getting ahead is getting started. — Mark Twain",
    "The harder you work for something, the greater you'll feel when you achieve it. — Unknown",
    "Discipline is choosing between what you want now and what you want most. — Abraham Lincoln",
    "Knowledge is being aware of what you can do. Wisdom is knowing when not to do it. — Anonymous",
  ];


  late String _currentQuote;


  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
    _randomizeQuote();
  }


  void _randomizeQuote() {
    final random = Random();
    _currentQuote = _motivationalQuotes[random.nextInt(_motivationalQuotes.length)];
  }


  void _addWelcomeMessage() {
    setState(() {
      _messages.add(Message(
        isUser: false,
        message: "Hello! I'm your Learnly AI assistant. I can help you with productivity tips, study techniques, motivation, or answer any questions about deep work. How can I help you today?",
        date: DateTime.now(),
      ));
    });
  }


  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }


  Future<void> sendMessage() async {
    final message = _userInput.text.trim();
    if (message.isEmpty) return;


    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
      _userInput.clear();
      _isLoading = true;
    });


    _scrollToBottom();


    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "You are Learnly AI, an assistant focused on helping users with productivity, motivation, deep work techniques, and distraction-free studying. Provide helpful, concise advice that encourages focus and effective learning. Now respond to this message: $message"
                }
              ]
            }
          ]
        }),
      );


      setState(() {
        _isLoading = false;
      });


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botReply;


        if (data is Map && data.containsKey("candidates") && data["candidates"] is List && data["candidates"].isNotEmpty) {
          botReply = data["candidates"][0]["content"]["parts"][0]["text"]?.trim() ?? "I don't know, sorry! Let me know if I can help with something else.";
        } else if (data is Map && data.containsKey("error")) {
          botReply = "I encountered a problem. Please try again later.";
        } else {
          botReply = "I'm having trouble processing your request.";
        }


        setState(() {
          _messages.add(Message(isUser: false, message: botReply, date: DateTime.now()));
        });
      } else if (response.statusCode == 429) {
        setState(() {
          _messages.add(Message(
            isUser: false,
            message: "I'm receiving too many requests right now. Please try again in a moment.",
            date: DateTime.now(),
          ));
        });
      } else {
        setState(() {
          _messages.add(Message(
            isUser: false,
            message: "I'm having trouble connecting. Please check your internet connection and try again.",
            date: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add(Message(
          isUser: false,
          message: "Something went wrong with our connection. Please try again.",
          date: DateTime.now(),
        ));
      });
    }


    _scrollToBottom();
  }


  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    
    final Color primaryBackground = _isDarkMode ? const Color(0xFF1A1A2E) : const Color(0xFFF8F7FA);
    final Color cardBackground = _isDarkMode ? const Color(0xFF2C2C44) : const Color(0xFFFFFFFF);
    final Color headerBackground = _isDarkMode ? const Color(0xFF362A84) : const Color(0xFFE6E0F0);
    final Color primaryAccent = const Color(0xFFB8E8E0); 
    final Color secondaryAccent = const Color(0xFF8CCFC5); 
    final Color primaryText = _isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    final Color secondaryText = _isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF333333);
    final Color inputBackground = _isDarkMode ? const Color(0xFF2C2C44) : const Color(0xFFF8F7FA);
    final Color shadowColor = _isDarkMode ? const Color(0xFF000000).withOpacity(0.2) : const Color(0xFF000000).withOpacity(0.05);


    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: AppBar(
        backgroundColor: headerBackground,
        elevation: 0,
        title: Text(
          "Learnly AI",
          style: TextStyle(
            color: primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'SFProDisplay',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
              color: primaryText,
            ),
            onPressed: _toggleTheme,
            tooltip: _isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: cardBackground,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outlined, color: primaryAccent, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _currentQuote,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'SFProDisplay',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh_outlined, color: secondaryText, size: 20),
                  onPressed: () {
                    setState(() {
                      _randomizeQuote();
                    });
                  },
                  tooltip: "Show another quote",
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  isUser: message.isUser,
                  message: message.message,
                  time: DateFormat('HH:mm').format(message.date),
                  userBubbleColor: primaryAccent,
                  aiBubbleColor: cardBackground,
                  textColor: message.isUser ? cardBackground : primaryText,
                  secondaryTextColor: secondaryText,
                  isDarkMode: _isDarkMode,
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryAccent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Thinking...",
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'SFProDisplay',
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cardBackground,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: inputBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isDarkMode ? const Color(0xFF3A3A50) : const Color(0xFFE6E0F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _userInput,
                              decoration: InputDecoration(
                                hintText: "Ask about productivity or studying...",
                                hintStyle: TextStyle(color: secondaryText, fontFamily: 'SFProDisplay'),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: primaryText,
                                fontFamily: 'SFProDisplay',
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              onSubmitted: (_) => sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.mic_outlined, color: primaryAccent),
                            onPressed: () {
                              
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  MaterialButton(
                    onPressed: sendMessage,
                    shape: const CircleBorder(),
                    color: primaryAccent,
                    padding: const EdgeInsets.all(12),
                    elevation: 0,
                    child: Icon(Icons.send_outlined, color: cardBackground, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Message {
  final bool isUser;
  final String message;
  final DateTime date;


  Message({required this.isUser, required this.message, required this.date});
}


class MessageBubble extends StatelessWidget {
  final bool isUser;
  final String message;
  final String time;
  final Color userBubbleColor;
  final Color aiBubbleColor;
  final Color textColor;
  final Color secondaryTextColor;
  final bool isDarkMode;


  const MessageBubble({
    Key? key,
    required this.isUser,
    required this.message,
    required this.time,
    required this.userBubbleColor,
    required this.aiBubbleColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.isDarkMode,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: isUser ? 48.0 : 16.0,
        right: isUser ? 16.0 : 48.0,
      ),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isUser ? userBubbleColor : aiBubbleColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? const Color(0xFF000000).withOpacity(0.1) : const Color(0xFF000000).withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                height: 1.4,
                fontFamily: 'SFProDisplay',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
                fontFamily: 'SFProDisplay',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

