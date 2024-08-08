import 'package:flutter/material.dart';
import 'task.dart';

typedef TaskCallback = void Function(
    String title, DateTime? date, TimeOfDay? time);

class AddTaskBottomSheet extends StatefulWidget {
  final TaskCallback onSave;
  final Task? task;

  const AddTaskBottomSheet(this.onSave, {Key? key, this.task})
      : super(key: key);

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _selectedDate = widget.task!.date;
      _selectedTime = widget.task!.time;
    }
  }

  void _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Picked Date: ${_selectedDate!.toLocal()}',
                ),
              ),
              TextButton(
                child: const Text('Choose Date'),
                onPressed: _selectDate,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _selectedTime == null
                      ? 'No Time Chosen!'
                      : 'Picked Time: ${_selectedTime!.format(context)}',
                ),
              ),
              TextButton(
                child: const Text('Choose Time'),
                onPressed: _selectTime,
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSave(
                _titleController.text,
                _selectedDate,
                _selectedTime,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
