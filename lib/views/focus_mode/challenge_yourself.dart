import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeYourself extends StatefulWidget {
  const ChallengeYourself({super.key});

  @override
  State<ChallengeYourself> createState() => _ChallengeYourselfState();
}

class _ChallengeYourselfState extends State<ChallengeYourself>
    with SingleTickerProviderStateMixin {
  // Challenge categories
  final Map<String, List<String>> challengeCategories = {
    '🎯 Focus': [
      'Study for 25 mins without distractions',
      'Read 2 pages of a book',
      'Work on one task for 15 minutes straight',
      'Write down your goals for the week',
    ],
    '💪 Self-Discipline': [
      'No social media for 2 hours',
      'Put your phone away for 3 hours',
      'Meditate for 5 minutes',
      'Do 10 pushups or jumping jacks',
    ],
    '📚 Knowledge': [
      'Explain a topic aloud',
      'Sketch a diagram from memory',
      'Summarize a topic in 3 sentences',
      'Practice a coding problem',
    ],
    '🧹 Environment': [
      'Tidy your desk',
      'Organize your study material',
      'Delete 5 unnecessary files',
      'Clean up your digital workspace',
    ],
  };

  // State variables
  String? currentChallenge;
  String? currentCategory;
  bool challengeStarted = false;
  bool challengeCompleted = false;
  bool isRolling = false;
  String? savedChallenge;
  String? savedCategory;
  
  // Streak and stats tracking
  int streak = 0;
  int totalCompleted = 0;
  int skipped = 0;
  
  // Animation controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Load saved data
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      streak = prefs.getInt('streak') ?? 0;
      totalCompleted = prefs.getInt('totalCompleted') ?? 0;
      skipped = prefs.getInt('skipped') ?? 0;
      savedChallenge = prefs.getString('savedChallenge');
      savedCategory = prefs.getString('savedCategory');
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', streak);
    await prefs.setInt('totalCompleted', totalCompleted);
    await prefs.setInt('skipped', skipped);
    
    if (savedChallenge != null && savedCategory != null) {
      await prefs.setString('savedChallenge', savedChallenge!);
      await prefs.setString('savedCategory', savedCategory!);
    } else {
      await prefs.remove('savedChallenge');
      await prefs.remove('savedCategory');
    }
  }

  void _rollChallenge() {
    setState(() {
      isRolling = true;
      challengeStarted = false;
      challengeCompleted = false;
    });
    
    _animationController.reset();
    _animationController.forward();
    
    // Simulate rolling animation with shorter delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final random = Random();
      
      // Select random category
      final categories = challengeCategories.keys.toList();
      final category = categories[random.nextInt(categories.length)];
      
      // Select random challenge from that category
      final challenges = challengeCategories[category]!;
      final challenge = challenges[random.nextInt(challenges.length)];
      
      setState(() {
        currentCategory = category;
        currentChallenge = challenge;
        isRolling = false;
      });
    });
  }

  void _startChallenge() {
    setState(() {
      challengeStarted = true;
    });
  }

  void _completeChallenge() {
    setState(() {
      challengeCompleted = true;
      streak += 1;
      totalCompleted += 1;
    });
    
    _saveData();
  }

  void _giveUpChallenge() {
    setState(() {
      challengeStarted = false;
      currentChallenge = null;
      currentCategory = null;
      skipped += 1;
    });
    
    _saveData();
  }

  void _saveForLater() {
    setState(() {
      savedChallenge = currentChallenge;
      savedCategory = currentCategory;
      currentChallenge = null;
      currentCategory = null;
    });
    
    _saveData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Challenge saved for later!'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _loadSavedChallenge() {
    setState(() {
      currentChallenge = savedChallenge;
      currentCategory = savedCategory;
      savedChallenge = null;
      savedCategory = null;
      challengeStarted = false;
      challengeCompleted = false;
    });
    
    _saveData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Challenge Yourself", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () => _showStatsDialog(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentChallenge == null && !isRolling) ...[
                  _buildWelcomeScreen(),
                ] else if (isRolling) ...[
                  _buildRollingAnimation(),
                ] else if (!challengeStarted) ...[
                  _buildChallengeReveal(),
                ] else if (!challengeCompleted) ...[
                  _buildActiveChallenge(),
                ] else ...[
                  _buildCompletionScreen(),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: savedChallenge != null
          ? _buildSavedChallengeBar()
          : null,
    );
  }

  Widget _buildWelcomeScreen() {
    return Column(
      children: [
        Icon(
          Icons.emoji_events, 
          size: 120, 
          color: Colors.tealAccent.withOpacity(0.7)
        ),
        const SizedBox(height: 20),
        const Text(
          "Push your limits. Discover your best self.",
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          onPressed: _rollChallenge,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Draw a Challenge", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Icon(Icons.casino),
            ],
          ),
        ),
        const SizedBox(height: 15),
        if (streak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  "$streak day streak",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRollingAnimation() {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.tealAccent.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationController.value * 4 * 3.14159,
                child: const Icon(
                  Icons.casino,
                  size: 60,
                  color: Colors.tealAccent,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Rolling the dice...",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildChallengeReveal() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                currentCategory ?? "",
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Challenge", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 15),
            Text(
              currentChallenge!, 
              style: const TextStyle(fontSize: 20), 
              textAlign: TextAlign.center
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _startChallenge,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 15),
                OutlinedButton.icon(
                  onPressed: _saveForLater,
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text("Save for Later"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _rollChallenge,
              child: const Text("Roll Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveChallenge() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.access_time, size: 40, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            const Text(
              "Challenge in Progress", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)
            ),
            const SizedBox(height: 15),
            Text(
              currentChallenge!, 
              style: const TextStyle(fontSize: 18), 
              textAlign: TextAlign.center
            ),
            const SizedBox(height: 20),
            _buildMotivationalQuote(),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _completeChallenge,
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Mark as Done"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 15),
                OutlinedButton.icon(
                  onPressed: _giveUpChallenge,
                  icon: const Icon(Icons.close),
                  label: const Text("Give Up"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote() {
    final quotes = [
      "Progress is better than perfection.",
      "Small steps lead to big changes.",
      "The only bad workout is the one that didn't happen.",
      "Consistency beats intensity.",
      "Every challenge you complete builds your power.",
    ];
    
    final random = Random();
    final quote = quotes[random.nextInt(quotes.length)];
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Text(
        '"$quote"',
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 60,
            ),
            const SizedBox(height: 15),
            const Text(
              "Challenge Complete! 🎉",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 15),
            Text(
              "You completed: $currentChallenge",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Growth meter visualization
            _buildGrowthMeter(),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _rollChallenge,
              icon: const Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              ),
              label: const Text("New Challenge"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthMeter() {
    // Calculate growth percentage based on completed challenges
    final growthPercentage = totalCompleted > 50 ? 1.0 : totalCompleted / 50;
    
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Growth Meter", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("50 challenges = 100%"),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6 * growthPercentage,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${(growthPercentage * 100).toInt()}%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavedChallengeBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.teal.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.bookmark, color: Colors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Saved: ${savedChallenge ?? ''}",
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            onPressed: _loadSavedChallenge,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text("Load"),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Your Stats", style: TextStyle(color: Colors.teal)),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        children: [
          _buildStatItem(Icons.local_fire_department, "Current Streak", "$streak days"),
          const Divider(),
          _buildStatItem(Icons.check_circle, "Challenges Completed", "$totalCompleted"),
          const Divider(),
          _buildStatItem(Icons.close, "Challenges Skipped", "$skipped"),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: totalCompleted / (totalCompleted + skipped + 1),
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
          const SizedBox(height: 8),
          Text(
            "Completion Rate: ${totalCompleted + skipped > 0 ? (totalCompleted / (totalCompleted + skipped) * 100).toInt() : 0}%",
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}