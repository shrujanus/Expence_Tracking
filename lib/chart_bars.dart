import 'package:flutter/material.dart';

class ChatBar extends StatelessWidget {
  const ChatBar(
      {Key? key,
      required this.label,
      required this.spendingAmount,
      required this.spendingPctofTotal})
      : super(key: key);
  final String label;
  final double spendingAmount;
  final double spendingPctofTotal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return Column(
        children: <Widget>[
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
                child: Text(
              '\$${spendingAmount.toStringAsFixed(0)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctofTotal,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            child: FittedBox(child: Text(label)),
            height: constraints.maxHeight * 0.15,
          ),
        ],
      );
    }));
  }
}
