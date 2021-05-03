import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Storage with ChangeNotifier {
  Future<void> addRecords(String title) async {
    final String time = DateFormat('dd-MM: hh:mm').format(DateTime.now());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('time') || prefs.getString('time').isEmpty) {
      await prefs.setString('time', json.encode({title: time}));

      notifyListeners();
    }

    final existingData =
        json.decode((prefs.getString('time'))) as Map<String, dynamic>;

    existingData.addAll({title: time});
    await prefs.setString('time', json.encode(existingData));

    notifyListeners();
  }

  Future<Map<String, dynamic>> getRecords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('time')) return null;

    return json.decode((prefs.getString('time')));
  }

  Future<String> updateRecord(String title) async {
    final String time = DateFormat('dd-MM: hh:mm').format(DateTime.now());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final existingData =
        json.decode((prefs.getString('time'))) as Map<String, dynamic>;

    existingData.update(title, (value) => time);
    await prefs.setString('time', json.encode(existingData));
    return time;
  }

  Future<void> deleteRecord(String title) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final existingData =
        json.decode((prefs.getString('time'))) as Map<String, dynamic>;

    existingData.remove(title);
    await prefs.setString('time', json.encode(existingData));

    notifyListeners();
  }
}
