import 'dart:ui';

import 'package:finance_app/components-services/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastify_flutter/toastify_flutter.dart';
import 'firebase_services.dart';

//Custom Header Widget
Widget header(
  String htext,
  String subtext,
  double fsize,
  Color? backgroundColor,
) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16),
    color: backgroundColor,
    child: Column(
      children: [
        Text(
          htext,
          style: TextStyle(fontSize: fsize, fontWeight: FontWeight.bold),
        ),
        Text(subtext),
      ],
    ),
  );
}

//Custom Elevated Button - bg: purple, text: white
Widget appButton({
  required BuildContext context,
  required String label,
  VoidCallback? onPressed,
  required String? routeName,
  bool replace = false,
}) {
  return ElevatedButton(
    onPressed:
        onPressed ??
        () {
          if (routeName == null) return;

          if (replace) {
            Navigator.pushReplacementNamed(context, routeName);
          } else {
            Navigator.pushNamed(context, routeName);
          }
        },
    style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      backgroundColor: const Color.fromARGB(150, 248, 187, 208),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 20, color: Colors.black),
    ),
  );
}

//Custom href text
Widget goToPage({
  required BuildContext context,
  String? prefixText,
  required String actionText,
  required String routeName,
  Color actionColor = const Color.fromARGB(147, 145, 14, 60),
}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, routeName);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixText != null) Text(prefixText),
        Text(
          actionText,
          style: TextStyle(
            color: actionColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Icon(Icons.arrow_forward),
      ],
    ),
  );
}

//Custom Display Card - income, expense cards
Widget displayCard({
  required BuildContext context,
  required String title,
  required String amount,
  required double inctotal,
  required double exptotal,
}) {
  return Card(
    elevation: 0,
    color: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(16),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height:  MediaQuery.of(context).size.width / 2 + 20,
          width:MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF8BBD0).withOpacity(0.35), // baby pink
                const Color(0xFFFCE4EC).withOpacity(0.25),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
              
              SizedBox(height: 5),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.arrow_down,
                              size: 15,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expense",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            Text(
                              "₹${exptotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.arrow_up,
                              size: 15,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            Text(
                              "Income",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            Text(
                              "₹${inctotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

//Custom InputField & SizedBox
Widget inputField({
  required TextEditingController controller,
  required String hintText,
  IconData prefixIcon = Icons.currency_rupee_rounded,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          fillColor: Color.fromARGB(255, 240, 196, 203),
          filled: true,
          prefixIcon: Icon(prefixIcon, color: Colors.black54, size: 28),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

//Custom Transaction Button
Widget transact({
  required BuildContext context,
  required String label,
  required String type, //income or expense
  required TextEditingController amtController,
  required String? category,
  TextEditingController? noteController,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElevatedButton(
        onPressed: () async {
          final amtText = amtController.text.trim();

          if (amtText.isEmpty || category == null) {
            ToastifyFlutter.error(
              context,
              message: "Please fill all required fields",
              duration: 5,
              position: ToastPosition.top,
              style: ToastStyle.flatColored,
            );
            return;
          }
          final amt = int.tryParse(amtText);
          if (amt == null || amt < 0) {
            ToastifyFlutter.error(
              context,
              message: "Enter a valid amount",
              duration: 5,
              position: ToastPosition.top,
              style: ToastStyle.flatColored,
            );
            return;
          }

          if (amt > 10000) {
            ToastifyFlutter.error(
              context,
              message: "Amount cannot exceed ₹10,000",
              duration: 5,
              position: ToastPosition.top,
              style: ToastStyle.flatColored,
            );
            return;
          }

          try {
            await addTransaction(
              type: type,
              amt: amt,
              category: category,
              note: noteController?.text.trim(),
            );

            ToastifyFlutter.success(
              context,
              message: "${type} added successfully",
              duration: 5,
              position: ToastPosition.top,
              style: ToastStyle.flatColored,
            );

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } catch (e) {
            ToastifyFlutter.error(
              context,
              message: e.toString(),
              duration: 5,
              position: ToastPosition.top,
              style: ToastStyle.flatColored,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
          backgroundColor: const Color.fromARGB(150, 248, 187, 208),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    ],
  );
}

//Custom Dropdown
Widget categories({
  required String? selectedCategory,
  required List<String> categories,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      //color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      //border: Border.all(color: Colors.black12),
    ),
    child: DropdownButton<String>(
      hint: Text("Select Category"),
      value: selectedCategory,
      isExpanded: true,
      onChanged: onChanged,
      items: categories.map((String c) {
        return DropdownMenuItem<String>(value: c, child: Text(c));
      }).toList(),
    ),
  );
}
