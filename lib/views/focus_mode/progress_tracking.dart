import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'time_tracker.dart'; //existing time tracker

class ProgressTrackerPage extends StatefulWidget {
  const ProgressTrackerPage({super.key});

  @override
  State<ProgressTrackerPage> createState() => _ProgressTrackerPageState();
}

class _ProgressTrackerPageState extends State<ProgressTrackerPage> {
  int totalStudyHours = 0;
  int tasksCompleted = 0;
  int rewardPoints = 0;

  // Sample weekly data
  List<double> weeklyProgress = [2, 4, 3, 5, 1, 0, 3]; 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245), 
      appBar: AppBar(
        title: const Text('Progress Tracker', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 240, 242, 245),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_circle_left_rounded, color: Color.fromARGB(255, 205, 154, 214)), 
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded, color: Color.fromARGB(255, 126, 28, 183)), 
            onPressed: () => setState(() {
              totalStudyHours = 0;
              tasksCompleted = 0;
              rewardPoints = 0;
              weeklyProgress = [0, 0, 0, 0, 0, 0, 0];
            }),
            tooltip: 'Reset Progress',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 20),
              _buildWeeklyChart(),
              const SizedBox(height: 20),
              _buildActionButton(
                context,
                icon: Icons.watch_later_rounded,
                label: 'Time Tracker',
                color: const Color.fromARGB(255, 195, 114, 163), 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TimeTrackerPage()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                context,
                icon: Icons.task_alt_rounded,
                label: 'Add Task',
                color: const Color.fromARGB(255, 197, 140, 227), 
                onPressed: () {
                  setState(() {
                    tasksCompleted++;
                    rewardPoints += 10;
                    weeklyProgress[DateTime.now().weekday % 7] += 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 220, 225, 230), width: 1), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_rounded, color: Color.fromARGB(255, 28, 109, 55), size: 24), // Steel Blue
              const SizedBox(width: 8),
              const Text(
                'Progress Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _progressRow('Study Hours', totalStudyHours, Icons.hourglass_bottom_rounded, const Color.fromARGB(255, 90, 160, 255)), 
          _progressRow('Tasks Done', tasksCompleted, Icons.check_circle_rounded, const Color.fromARGB(255, 120, 200, 120)), 
          _progressRow('Points', rewardPoints, Icons.star_rounded, const Color.fromARGB(255, 225, 210, 52)),
        ],
      ),
    );
  }

  Widget _progressRow(String title, int value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2, // Subtle shadow for depth
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(255, 220, 225, 230), width: 1), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, color: Color.fromARGB(255, 70, 130, 180), size: 24),
              const SizedBox(width: 8),
              const Text(
                'Weekly Progress',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: const Color.fromARGB(255, 70, 130, 180),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} hr',
                        const TextStyle(color: Colors.white, fontSize: 12),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, _) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(
                          days[value.toInt() % 7],
                          style: const TextStyle(color: Colors.black, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) {
                        if (value % 2 == 0) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(color: Colors.black, fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: const Color.fromARGB(255, 220, 225, 230), strokeWidth: 1); 
                  },
                ),
                barGroups: weeklyProgress.asMap().entries.map((entry) {
                  int index = entry.key;
                  double value = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        color: const Color.fromARGB(255, 206, 123, 215), 
                        borderRadius: BorderRadius.circular(4),
                        width: 14,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}