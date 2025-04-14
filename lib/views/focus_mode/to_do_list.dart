import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<String> _tasks = [];
  final List<String> _completedTasks = [];
  final TextEditingController _controller = TextEditingController();

  final List<String> _motivations = [
    "You're amazing! Keep going ✨",
    "One step closer to success 💪",
    "Great job! You're doing well ✨",
    "Task done! Celebrate small wins 🎉",
    "You’re unstoppable 🚀"
  ];

  void _addTask(String task) {
    if (task.trim().isEmpty) return;
    setState(() {
      _tasks.add(task);
    });
    _controller.clear();
    Navigator.of(context).pop();
  }

  void _editTask(int index) {
    TextEditingController editController = TextEditingController(text: _tasks[index]);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: editController,
                  decoration: InputDecoration(
                    hintText: 'Edit your task ✍️',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (editController.text.trim().isEmpty) return;
                    setState(() {
                      _tasks[index] = editController.text;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _completeTask(int index) {
    final message = (_motivations..shuffle()).first;
    setState(() {
      _completedTasks.add(_tasks[index]);
      _tasks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal.shade200,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter your task ✍️',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _addTask(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Add Task',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskList() {
    if (_tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks yet! Add some 📝',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade200,
              child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(
              _tasks[index],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => _editTask(index),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.teal),
                  onPressed: () => _completeTask(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedTaskList() {
    if (_completedTasks.isEmpty) {
      return Center(
        child: Text(
          'No completed tasks yet! 🌟',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _completedTasks.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.teal.shade50,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade400,
              child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(
              _completedTasks[index],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Task List 📝'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Tasks'),
              Tab(text: 'Completed Tasks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(),
            _buildCompletedTaskList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          backgroundColor: Colors.teal.shade300,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
