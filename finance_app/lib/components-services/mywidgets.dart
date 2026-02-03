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
      backgroundColor: Colors.purple.withOpacity(0.7),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 20, color: Colors.white),
    ),
  );
}

//Custom href text
Widget goToPage({
  required BuildContext context,
  String? prefixText,
  required String actionText,
  required String routeName,
  Color actionColor = Colors.purple,
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
  //required String goToText,
  //required String appRoute,
  required double height,
  required double width,
  Color backgroundColor = const Color(0xFFFDE7D3),
  //IconData icon = Icons.trending_up,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(16),
    ),
    child: Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.purple.withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
          ),
          //Icon(icon),
          SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.arrow_down,
                          size: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Expense",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        Text(
                          "₹${exptotal.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
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
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.arrow_up,
                          size: 12,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Income",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        Text(
                          "₹${inctotal.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          //goToPage(
          //context: context,
          //actionText: goToText,
          //routeName: appRoute,
          //actionColor: Colors.black,
          //),
        ],
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
          fillColor: Colors.purple.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(prefixIcon),
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
  return ElevatedButton(
    child: Text(label),
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

      try {
        await addTransaction(
          type: type,
          amt: amt,
          category: category,
          note: noteController?.text.trim() ?? "",
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
  );
}

//Custom Dropdown
Widget categories({
  required String? selectedCategory,
  required List<String> categories,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButton<String>(
    hint: Text("Select Category"),
    value: selectedCategory,
    isExpanded: true,
    onChanged: onChanged,
    items: categories.map((String c) {
      return DropdownMenuItem<String>(value: c, child: Text(c));
    }).toList(),
  );
}
