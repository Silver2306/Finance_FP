import 'package:flutter/material.dart';
import '../components-services/mywidgets.dart';

class Addexp extends StatefulWidget {
  const Addexp({super.key});

  @override
  State<Addexp> createState() => _AddexpState();
}

class _AddexpState extends State<Addexp> {
  TextEditingController amtcontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();
  final List<String> _categories = [
    'Food',
    'Clothes',
    'Travel',
    'Gifts',
    'Entertainment',
    'College',
    'Misc',
  ];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputField(
              controller: amtcontroller,
              hintText: "Enter Amount",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee_rounded,
            ),
            categories(
              selectedCategory: _selectedCategory,
              categories: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            inputField(
              controller: notecontroller,
              hintText: "Notes/Description",
              prefixIcon: Icons.notes,
            ),
            transact(
              context: context,
              label: "Add Expense",
              type: 'expense',
              amtController: amtcontroller,
              category: _selectedCategory,
              noteController: notecontroller,
            ),
          ],
        ),
      ),
    );
  }
}
