import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Task {
  String title;
  bool isCompleted;

  Task(this.title, this.isCompleted);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Mengatur latar belakang putih
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Task> _tasks = <Task>[];
  final List<Task> _completedTasks = <Task>[];
  final TextEditingController _taskController = TextEditingController();
  int _selectedTabIndex = 0;

  void _addTask() {
    final title = _taskController.text;
    if (title.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title, false));
        _taskController.clear();
      });
    }
  }

  void _toggleTask(int index, List<Task> sourceList, List<Task> targetList) {
    setState(() {
      final task = sourceList[index];
      task.isCompleted = !task.isCompleted;
      sourceList.removeAt(index);
      targetList.add(task);
    });
  }

  void _deleteTask(int index, List<Task> sourceList) {
    setState(() {
      sourceList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: _buildTaskList(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'To-Do List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Completed Tasks',
          ),
        ],
        currentIndex: _selectedTabIndex, // Mengatur tab yang aktif
        onTap: (int index) {
          setState(() {
            _selectedTabIndex = index; // Mengubah tab yang aktif
          });
        },
      ),
    );
  }

  Widget _buildTaskList() {
    if (_selectedTabIndex == 0) {
      return _buildTaskListView(_tasks);
    } else if (_selectedTabIndex == 2) {
      return _buildTaskListView(_completedTasks);
    } else {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Task',
                hintText: 'Enter your task',
                prefixIcon: Icon(Icons.assignment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTaskListView(List<Task> taskList) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (BuildContext context, int index) {
        final task = taskList[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: InkWell(
            onTap: () {
              _toggleTask(index, taskList, _completedTasks);
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  _toggleTask(index, taskList, _completedTasks);
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 18.0,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteTask(index, taskList);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
