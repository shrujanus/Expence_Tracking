import 'package:flutter/cupertino.dart';

class Transcation {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transcation(
      {required this.id,
      required this.date,
      required this.amount,
      required this.title});
}
