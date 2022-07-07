import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './transaction.dart';
import './chart_bars.dart';

class Chart extends StatelessWidget {
  final List<Transcation> recentTranascation;

  Chart({required this.recentTranascation, Key? key}) : super(key: key);
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTranascation.length; i++) {
        if (recentTranascation[i].date.day == weekDay.day &&
            recentTranascation[i].date.month == weekDay.month &&
            recentTranascation[i].date.year == weekDay.year) {
          totalSum += recentTranascation[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + double.parse(item['amount'].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChatBar(
                  label: data['day'].toString(),
                  spendingAmount: double.parse(data['amount'].toString()),
                  spendingPctofTotal: totalSpending == 0.0
                      ? 0.0
                      : (double.parse(data['amount'].toString()) /
                          totalSpending)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
