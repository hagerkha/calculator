import 'button.dart';
import 'package:flutter/material.dart';
import "package:math_expressions/math_expressions.dart";

class Home extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const Home({super.key, required this.themeNotifier});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeNotifier.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              setState(() {
                widget.themeNotifier.value = widget.themeNotifier.value == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: inputController,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Input',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    buildButtonRow(["AC", "C", "%", "÷"], screenSize, Colors.white),
                    buildButtonRow(["7", "8", "9", "×"], screenSize, Colors.white),
                    buildButtonRow(["4", "5", "6", "-"], screenSize, Colors.white),
                    buildButtonRow(["1", "2", "3", "+"], screenSize, Colors.white),
                    buildButtonRow(["0", ".", "="], screenSize, Colors.blueGrey, isLastRow: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> values, Size screenSize, Color color, {bool isLastRow = false}) {
    return Expanded(
      child: Row(
        children: values.map((value) {
          return Expanded(
            flex: (value == "0") ? 2 : 1,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () => onButtonPressed(value),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  textStyle: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                child: Text(value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void onButtonPressed(String value) {
    setState(() {
      if (value == "AC") {
        inputController.clear();
      } else if (value == "C") {
        inputController.text = inputController.text.length > 1
            ? inputController.text.substring(0, inputController.text.length - 1)
            : "";
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );
      } else if (value == "=") {
        calculateResult();
      } else {
        inputController.text += value;
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );
      }
    });
  }

  void calculateResult() {
    String userInput = inputController.text.replaceAll('×', '*').replaceAll('÷', '/');
    Parser p = Parser();
    Expression exp = p.parse(userInput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    inputController.text = eval.toString();
    inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: inputController.text.length),
    );
  }
}
