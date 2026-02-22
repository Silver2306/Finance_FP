import 'package:flutter/material.dart';
import '../components-services/mywidgets.dart';

class Addinc extends StatefulWidget {
  const Addinc({super.key});

  @override
  State<Addinc> createState() => _AddincState();
}

class _AddincState extends State<Addinc> {
  TextEditingController amtcontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();
  final List<String> _categories = [
    'Salary',
    'Pocket Money',
    'Misc',
    'Investment',
    'Gift',
  ];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Add Income")),
      body: SingleChildScrollView(
        child: Padding(
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
                label: "Add Income",
                type: 'income',
                amtController: amtcontroller,
                category: _selectedCategory,
                noteController: notecontroller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
