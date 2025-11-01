import 'package:flutter/material.dart';
import 'database_helper.dart'; // 👈 make sure this file is in your lib folder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();
  final dbHelper = DatabaseHelper();

  String result = "";
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory(); // Load previous calculations on app start
  }

  Future<void> loadHistory() async {
    List<Map<String, dynamic>> data = await dbHelper.getHistory();
    setState(() {
      history = data;
    });
  }

  Future<void> calculate(String op) async {
    double n1 = double.tryParse(num1Controller.text) ?? 0;
    double n2 = double.tryParse(num2Controller.text) ?? 0;
    double res = 0;

    switch (op) {
      case '+':
        res = n1 + n2;
        break;
      case '-':
        res = n1 - n2;
        break;
      case '*':
        res = n1 * n2;
        break;
      case '/':
        if (n2 != 0) {
          res = n1 / n2;
        } else {
          setState(() {
            result = "Cannot divide by zero";
          });
          return;
        }
        break;
    }

    String expression = "$n1 $op $n2";
    String resultValue = res.toString();

    // Save to database
    await dbHelper.insertHistory(expression, resultValue);

    // Reload the updated history
    await loadHistory();

    setState(() {
      result = "Result: $res";
    });
  }

  Future<void> clearAllHistory() async {
    await dbHelper.clearHistory();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter first number",
              ),
            ),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter second number",
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => calculate('+'),
                  child: const Text("+"),
                ),
                ElevatedButton(
                  onPressed: () => calculate('-'),
                  child: const Text("-"),
                ),
                ElevatedButton(
                  onPressed: () => calculate('*'),
                  child: const Text("×"),
                ),
                ElevatedButton(
                  onPressed: () => calculate('/'),
                  child: const Text("÷"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: clearAllHistory,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Clear History"),
            ),
            const SizedBox(height: 10),
            const Text(
              "History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text("No history yet"))
                  : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['expression']),
                      subtitle: Text("= ${item['result']}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
