import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeController extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  Future<String> selectDate(
      BuildContext context, TextEditingController date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) {
      selectedDate = picked;
      date.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      notifyListeners();
      return selectedDate.toString();
    } else {
      return DateTime.now().toString();
    }
  }

  Future<String> selecteTime(
      BuildContext context, TextEditingController time) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime = picked;
      time.text = selectedTime?.format(context) ?? "";
      notifyListeners();
      return selectedTime.toString();
    } else {
      return TimeOfDay.now().toString();
    }
  }
}
