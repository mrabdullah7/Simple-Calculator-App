import 'package:flutter/material.dart';

void main(){
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  double? _num1;
  String _operation = "";
  bool _shouldReset = false;

  String formatNumber(double number) {
    if (number % 1 == 0) {
      return number.toInt().toString();
    } else {
      return number.toString();
    }
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = null;
        _operation = "";
        _shouldReset = false;
      } else if (buttonText == "⌫") {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          _output = _currentInput.isEmpty ? "0" : _currentInput;
        }
      } else if (["+", "-", "×", "÷"].contains(buttonText)) {
        if (_currentInput.isNotEmpty) {
          _num1 = double.tryParse(_currentInput);
          _operation = buttonText;
          _output = "$_currentInput $_operation";
          _currentInput = "";
          _shouldReset = false;
        } else if (_output.isNotEmpty && _num1 != null) {
          _operation = buttonText;
          _output = "${formatNumber(_num1!)} $_operation";
        }
      } else if (buttonText == "=") {
        if (_operation.isNotEmpty && _currentInput.isNotEmpty && _num1 != null) {
          double num2 = double.tryParse(_currentInput) ?? 0;
          double? result;
          switch (_operation) {
            case "+":
              result = _num1! + num2;
              break;
            case "-":
              result = _num1! - num2;
              break;
            case "×":
              result = _num1! * num2;
              break;
            case "÷":
              if (num2 == 0) {
                _output = "Error";
                _currentInput = "";
                _num1 = null;
                _operation = "";
                return;
              } else {
                result = _num1! / num2;
              }
              break;
          }

          if (result != null) {
            _output = formatNumber(result);
            _currentInput = _output;
            _num1 = null;
            _operation = "";
            _shouldReset = true;
          }
        }
      } else {
        if (_shouldReset) {
          _currentInput = buttonText;
          _shouldReset = false;
        } else {
          _currentInput += buttonText;
        }
        _output = _operation.isEmpty
            ? _currentInput
            : "${formatNumber(_num1 ?? 0)} $_operation $_currentInput";
      }
    });
  }

  Widget _buildButton(String text, [Color? color]) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: MaterialButton(
        color: color ?? Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(20),
        onPressed: () => _buttonPressed(text),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color != null ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Text(
                _output,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(12),
              children: [
                _buildButton("C", Colors.redAccent),
                const SizedBox(), // empty
                const SizedBox(), // empty
                _buildButton("⌫", Colors.blueGrey),

                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("÷", Colors.orange),

                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("×", Colors.orange),

                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("-", Colors.orange),

                _buildButton("0"),
                _buildButton("."),
                _buildButton("=", Colors.orange),
                _buildButton("+", Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
