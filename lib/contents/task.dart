import 'package:isar/isar.dart';
import 'package:flutter/material.dart';

part 'task.g.dart'; // This file will be generated by Isar

@Collection()
class Task {
  Id id = Isar.autoIncrement; // Use auto-incrementing ID

  late String title;
  DateTime? date;

  @Ignore() // Ignore the TimeOfDay field for Isar
  TimeOfDay? time;

  Task({required this.title, this.date, this.time});
}
