import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../profile/profile.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // Enhanced color palette for a modern look
    const Color primaryBackground = Color(0xFFF8F7FA); // Light Background
    const Color cardBackground = Color(0xFFFFFFFF); // Pure White
    const Color headerBackground = Color(0xFFE6E0F0); // Light Purple/Lavender
    const Color primaryAccent = Color(0xFFB8E8E0); // Mint/Light Teal
    const Color secondaryAccent = Color(0xFF8CCFC5); // Darker Mint
    const Color primaryText = Color(0xFF000000); // Black
    const Color secondaryText = Color(0xFF333333); // Dark Gray
    const Color accentText = Color(0xFF5D5FEF); // Purple/Blue for emphasis


    return Scaffold(
      backgroundColor: headerBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, primaryText, secondaryText, secondaryAccent, cardBackground, accentText),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: primaryBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          _buildDailyScore(primaryAccent, secondaryAccent, primaryText, secondaryText, cardBackground, accentText),
                          const SizedBox(height: 24),
                          _buildMoodSelector(primaryText, secondaryText, primaryAccent, secondaryAccent, accentText),
                          const SizedBox(height: 24),
                          _buildTrackerGrid(primaryAccent, secondaryAccent, primaryText, secondaryText, cardBackground, accentText),
                          const SizedBox(height: 24),
                          _buildRecentActivity(primaryAccent, secondaryAccent, primaryText, secondaryText, cardBackground, accentText),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context, Color primaryText, Color secondaryText, Color secondaryAccent, Color cardBackground, Color accentText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryText.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: secondaryAccent,
                    backgroundImage: const AssetImage('assets/images/profile_placeholder.png'),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: cardBackground, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SFProDisplay',
                    ),
                  ),
                  Text(
                    'Hridoy',
                    style: TextStyle(
                      color: accentText,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProDisplay',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryText.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.search, color: primaryText, size: 22),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryText.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.notifications_outlined, color: primaryText, size: 22),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildDailyScore(Color primaryAccent, Color secondaryAccent, Color primaryText, Color secondaryText, Color cardBackground, Color accentText) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryText.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardBackground, cardBackground.withOpacity(0.9)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Score',
                    style: TextStyle(
                      color: accentText,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFProDisplay',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your productivity summary',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      fontFamily: 'SFProDisplay',
                    ),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 7.0,
                animation: true,
                animationDuration: 1500,
                percent: 0.72,
                center: Text(
                  "72%",
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    fontFamily: 'SFProDisplay',
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: primaryAccent,
                backgroundColor: secondaryAccent.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearPercentIndicator(
            animation: true,
            lineHeight: 8.0,
            animationDuration: 1500,
            percent: 0.72,
            barRadius: const Radius.circular(4),
            progressColor: primaryAccent,
            backgroundColor: secondaryAccent.withOpacity(0.3),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }


  Widget _buildMoodSelector(Color primaryText, Color secondaryText, Color primaryAccent, Color secondaryAccent, Color accentText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling today?',
          style: TextStyle(
            color: accentText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'SFProDisplay',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 95,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildMoodIcon('😃', primaryAccent, 'Great', primaryText, secondaryText),
              const SizedBox(width: 14),
              _buildMoodIcon('😊', secondaryAccent, 'Good', primaryText, secondaryText),
              const SizedBox(width: 14),
              _buildMoodIcon('😐', secondaryAccent, 'Okay', primaryText, secondaryText),
              const SizedBox(width: 14),
              _buildMoodIcon('😔', secondaryAccent, 'Low', primaryText, secondaryText),
              const SizedBox(width: 14),
              _buildMoodIcon('😴', secondaryAccent, 'Tired', primaryText, secondaryText),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildMoodIcon(String emoji, Color color, String label, Color primaryText, Color secondaryText) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: primaryText.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: secondaryText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'SFProDisplay',
          ),
        ),
      ],
    );
  }


  Widget _buildTrackerGrid(Color primaryAccent, Color secondaryAccent, Color primaryText, Color secondaryText, Color cardBackground, Color accentText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: TextStyle(
            color: accentText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'SFProDisplay',
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: [
            _buildTrackerItem(
              title: 'Study Progress',
              value: '75%',
              time: '3h today',
              icon: Icons.school,
              color: primaryAccent,
              progressValue: 0.75,
              primaryText: primaryText,
              secondaryText: secondaryText,
              cardBackground: cardBackground,
              secondaryAccent: secondaryAccent,
            ),
            _buildTrackerItem(
              title: 'Focus Time',
              value: '2h 15m',
              time: 'Today',
              icon: Icons.timer,
              color: secondaryAccent,
              progressValue: 0.6,
              primaryText: primaryText,
              secondaryText: secondaryText,
              cardBackground: cardBackground,
              secondaryAccent: secondaryAccent,
            ),
            _buildTrackerItem(
              title: 'Tasks Completed',
              value: '9/12',
              time: 'Today',
              icon: Icons.check_circle,
              color: primaryAccent,
              progressValue: 0.75,
              primaryText: primaryText,
              secondaryText: secondaryText,
              cardBackground: cardBackground,
              secondaryAccent: secondaryAccent,
            ),
            _buildTrackerItem(
              title: 'Distraction-Free',
              value: '1h 30m',
              time: 'Today',
              icon: Icons.do_not_disturb_on,
              color: secondaryAccent,
              progressValue: 0.45,
              primaryText: primaryText,
              secondaryText: secondaryText,
              cardBackground: cardBackground,
              secondaryAccent: secondaryAccent,
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildTrackerItem({
    required String title,
    required String value,
    required String time,
    required IconData icon,
    required Color color,
    required double progressValue,
    required Color primaryText,
    required Color secondaryText,
    required Color cardBackground,
    required Color secondaryAccent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryText.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardBackground, cardBackground.withOpacity(0.95)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: cardBackground,
                  size: 18,
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SFProDisplay',
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: primaryText,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: 'SFProDisplay',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: secondaryText,
              fontSize: 14,
              fontFamily: 'SFProDisplay',
            ),
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            lineHeight: 6.0,
            percent: progressValue,
            barRadius: const Radius.circular(3),
            progressColor: color,
            backgroundColor: secondaryAccent.withOpacity(0.3),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }


  Widget _buildRecentActivity(Color primaryAccent, Color secondaryAccent, Color primaryText, Color secondaryText, Color cardBackground, Color accentText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                color: accentText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFProDisplay',
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  color: primaryAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SFProDisplay',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          title: 'Completed Pomodoro Session',
          subtitle: '4 sessions × 25 minutes',
          time: '1h ago',
          icon: Icons.timer,
          color: primaryAccent,
          primaryText: primaryText,
          secondaryText: secondaryText,
          cardBackground: cardBackground,
        ),
        _buildActivityItem(
          title: 'Blocked Distractions',
          subtitle: '15 attempts blocked',
          time: '2h ago',
          icon: Icons.block,
          color: secondaryAccent,
          primaryText: primaryText,
          secondaryText: secondaryText,
          cardBackground: cardBackground,
        ),
        _buildActivityItem(
          title: 'Earned Achievement',
          subtitle: 'Consistency Master',
          time: '3h ago',
          icon: Icons.emoji_events,
          color: primaryAccent,
          primaryText: primaryText,
          secondaryText: secondaryText,
          cardBackground: cardBackground,
        ),
      ],
    );
  }


  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
    required Color primaryText,
    required Color secondaryText,
    required Color cardBackground,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryText.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: cardBackground,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SFProDisplay',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 14,
                    fontFamily: 'SFProDisplay',
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'SFProDisplay',
            ),
          ),
        ],
      ),
    );
  }
}

