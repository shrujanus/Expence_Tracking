// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_exp/chart.dart';
import 'package:flutter/cupertino.dart';

import './transaction_list.dart';
import './new_transaction.dart';
import './transaction.dart';
import './chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expences',
      home: MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.redAccent),
        fontFamily: 'Quicksand',
        errorColor: Color.fromRGBO(244, 124, 54, 1).withOpacity(0.8),
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              titleSmall: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          toolbarTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )
              .bodyText2,
          titleTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                titleMedium: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                titleSmall: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )
              .headline6,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transcation> _userTansaction = [
    Transcation(id: 't1', date: DateTime.now(), amount: 200, title: 'repair'),
    Transcation(id: 't2', date: DateTime.now(), amount: 20, title: 'hat'),
    Transcation(id: 't3', date: DateTime.now(), amount: 6.99, title: 'coffe')
  ];
  bool _showChart = false;

  List<Transcation> get _recentTransactions {
    return _userTansaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTX = Transcation(
        amount: txAmount,
        title: txTitle,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTansaction.add(newTX);
    });
  }

  void startAddNewTx(BuildContext ctx) {
    showAnimatedDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: true,
      alignment: Alignment.center,
      context: ctx,
      builder: (bCtx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: NewTransaction(_addNewTransactions),
              padding: EdgeInsets.all(5),
            )
          ],
        );
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 450),
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTansaction.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text('Expences'),
      actions: <Widget>[
        IconButton(
            onPressed: () => {startAddNewTx(context)}, icon: Icon(Icons.add))
      ],
    );
    final txListWidget = Container(
      child: TransactionList(_userTansaction, _deleteTransaction),
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch.adaptive(
                      activeColor: Colors.red,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLandscape)
              Container(
                child: Chart(recentTranascation: _recentTransactions),
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      child: Chart(recentTranascation: _recentTransactions),
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                    )
                  : txListWidget
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody)
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      startAddNewTx(context);
                    },
                    focusColor: Colors.red,
                    splashColor: Colors.red,
                    child: Icon(Icons.add),
                  ),
          );
  }
}
