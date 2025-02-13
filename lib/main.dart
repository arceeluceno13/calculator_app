import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '0';

  void onButtonClick(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        input = '';
        result = '0';
      } else if (buttonText == '=') {
        try {
          result = eval(input);
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += buttonText;
      }
    });
  }

  String eval(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm).toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget buildButton(String text, {Color color = Colors.grey}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onButtonClick(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Text(input.isEmpty ? '0' : input, style: TextStyle(fontSize: 40, color: Colors.white)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Text(result, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.green)),
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                buildRow(['7', '8', '9', '÷']),
                buildRow(['4', '5', '6', '×']),
                buildRow(['1', '2', '3', '-']),
                buildRow(['C', '0', '=', '+']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) => buildButton(btn, color: btn == '=' ? Colors.orange : Colors.grey[800]!)).toList(),
      ),
    );
  }
}
