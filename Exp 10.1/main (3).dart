import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String result = "";
  bool showHistory = false;

  // ✅ Function to calculate and save result in Firestore
  void calculate(String op) async {
    double n1 = double.tryParse(num1Controller.text) ?? 0;
    double n2 = double.tryParse(num2Controller.text) ?? 0;
    double res = 0;
    String operation = "";

    switch (op) {
      case '+':
        res = n1 + n2;
        operation = '+';
        break;
      case '-':
        res = n1 - n2;
        operation = '-';
        break;
      case '*':
        res = n1 * n2;
        operation = '×';
        break;
      case '/':
        if (n2 != 0) {
          res = n1 / n2;
          operation = '÷';
        } else {
          setState(() {
            result = "Cannot divide by zero";
          });
          return;
        }
        break;
    }

    // Save to Firestore
    await firestore.collection('history').add({
      'num1': n1,
      'num2': n2,
      'operator': operation,
      'result': res,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      result = "Result: $res";
    });
  }

  // ✅ Clear all documents in Firestore
  Future<void> clearHistory() async {
    final collection = await firestore.collection('history').get();
    for (var doc in collection.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultsQuery = firestore
        .collection('history')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Calculator"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              showHistory ? Icons.history_toggle_off : Icons.history,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                showHistory = !showHistory;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: clearHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter first number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter second number",
                border: OutlineInputBorder(),
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (showHistory)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: resultsQuery.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("No history yet");
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data =
                        docs[index].data() as Map<String, dynamic>;
                        final n1 = data['num1'];
                        final n2 = data['num2'];
                        final op = data['operator'];
                        final res = data['result'];

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 4),
                          child: ListTile(
                            leading: const Icon(Icons.calculate,
                                color: Colors.blueAccent),
                            title: Text("$n1 $op $n2 = $res"),
                          ),
                        );
                      },
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
