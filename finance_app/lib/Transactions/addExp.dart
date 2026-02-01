import 'package:flutter/material.dart';
import '../mywidgets.dart';
import '../routes.dart';

class Addexp extends StatefulWidget {
  const Addexp({super.key});

  @override
  State<Addexp> createState() => _AddexpState();
}

class _AddexpState extends State<Addexp> {

  TextEditingController amtcontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();
  List<String> _categories = ['Food', 'Clothes', 'Travel', 'Gifts', 'Entertainment', 'College'];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputField(controller: amtcontroller, hintText: "Enter Amount", keyboardType: TextInputType.number, prefixIcon: Icons.currency_rupee_rounded),
            DropdownButton<String>(
              hint: const Text("Select Category"),
              value: _selectedCategory,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            inputField(controller: notecontroller, hintText: "Notes/Description", prefixIcon: Icons.notes),
            appButton(context: context, label: "Add", routeName: AppRoutes.home)
          ],
        ),
      ),
    );
  }
}