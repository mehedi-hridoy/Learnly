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

  // api key from my mdmehedi4666424 account 2nd one after hugging face and other free api fails 

  final String apiKey = "AIzaSyCyQLP7BkeMAj7mSOj1wBnZycXDelsB8A0";
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

// Some motivational quotes for people to get ingaged and out of distraction 

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
  "Knowledge is being aware of what you can do. Wisdom is knowing when not to do it. — Anonymous"
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
        date: DateTime.now()
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

    // Ai chatbot scroll button design 

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
                {"text": "You are Learnly AI, an assistant focused on helping users with productivity, motivation, deep work techniques, and distraction-free studying. Provide helpful, concise advice that encourages focus and effective learning. Now respond to this message: $message"}
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
    
    // Scrolling upto bottom method 

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final primaryColor = _isDarkMode ? Color(0xFF7E57C2) : Color(0xFF5E35B1);
    final backgroundColor = _isDarkMode 
        ? [Color(0xFF1A1A2E), Color(0xFF16213E)]
        : [Color(0xFFF3E5F5), Color(0xFFE1BEE7)];
    final cardColor = _isDarkMode ? Color(0xFF262A56) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Color(0xFF424242);
    final secondaryTextColor = _isDarkMode ? Colors.grey[300] : Colors.grey[700];
    final userBubbleColor = _isDarkMode ? Color(0xFF7E57C2) : Color(0xFF9575CD);
    final inputBgColor = _isDarkMode ? Color(0xFF2C2C44) : Colors.grey[100]!;
    final hintTextColor = _isDarkMode ? Colors.grey[400]! : Colors.grey[500]!;
    final scaffoldBgColor = _isDarkMode ? Color(0xFF121212) : Colors.white;
    final quoteBannerColor = _isDarkMode 
        ? Color(0xFF362A84).withOpacity(0.95)
        : Color(0xFF5E35B1).withOpacity(0.9);
    final shadowColor = _isDarkMode ? Colors.black45 : Colors.black12;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          "Learnly AI",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nights_stay, 
              color: Colors.white
            ),
            onPressed: _toggleTheme,
            tooltip: _isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColor,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
           
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: quoteBannerColor,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.amber[300], size: 24),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _currentQuote,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white.withOpacity(0.7), size: 18),
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
            // Chat area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return MessageBubble(
                    isUser: message.isUser,
                    message: message.message,
                    time: DateFormat('HH:mm').format(message.date),
                    userBubbleColor: userBubbleColor,
                    aiBubbleColor: cardColor,
                    textColor: message.isUser ? Colors.white : textColor,
                    secondaryTextColor: secondaryTextColor!,
                    isDarkMode: _isDarkMode,
                  );
                },
              ),
            ),


            // Indicator design 

            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Thinking...",
                      style: TextStyle(
                        color: _isDarkMode ? Colors.grey[300] : primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            // Input area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isDarkMode ? Color(0xFF1E1E30) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: inputBgColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _isDarkMode ? Colors.grey[800]! : Colors.grey[300]!
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _userInput,
                                decoration: InputDecoration(
                                  hintText: "Ask about productivity or studying...",
                                  hintStyle: TextStyle(color: hintTextColor),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _isDarkMode ? Colors.white : Colors.black87,
                                ),
                                textCapitalization: TextCapitalization.sentences,
                                onSubmitted: (_) => sendMessage(),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.mic, color: primaryColor),
                              onPressed: () {
                                // Dummy voice input . need to implement further the logic
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    MaterialButton(
                      onPressed: sendMessage,
                      shape: CircleBorder(),
                      color: primaryColor,
                      padding: EdgeInsets.all(14),
                      elevation: 2,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        left: isUser ? 64.0 : 0,
        right: isUser ? 0 : 64.0,
      ),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isUser ? userBubbleColor : aiBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? 16 : 4),
                topRight: Radius.circular(isUser ? 4 : 16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.06),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}