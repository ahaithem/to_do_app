import 'package:flutter/material.dart';
import 'dart:math';
import 'task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final void Function(BuildContext context, Task task) editTask;
  final void Function(BuildContext context, Task task) finishTask;

  TaskItem({
    required this.task,
    required this.editTask,
    required this.finishTask,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _isChecked = false;
  late Color _backgroundColor;

  final List<Color> colorsOfItem = [
    Color(0xFFECE3CE),
    Color(0xFF739072),
    Color(0xFF4F6F52),
    Color(0xFF3A4D39),
  ];

  @override
  void initState() {
    super.initState();
    _backgroundColor = _generateRandomColor();
  }

  Color _generateRandomColor() {
    final random = Random();
    return colorsOfItem[random.nextInt(colorsOfItem.length)];
  }

  void _handleCheckboxChange(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });

    if (_isChecked) {
      widget.finishTask(context, widget.task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.task.title}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (widget.task.date != null)
                    Text(
                      '${widget.task.date!.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  if (widget.task.time != null)
                    Text(
                      '${widget.task.time!.format(context)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: _handleCheckboxChange,
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () => widget.editTask(context, widget.task),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
