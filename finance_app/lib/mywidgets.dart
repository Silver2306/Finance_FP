import 'package:flutter/material.dart';

Widget header(String htext, String subtext, double fsize) {
  return Column(
    children: [
      Text(
        htext,
        style: TextStyle(fontSize: fsize, fontWeight: FontWeight.bold),
      ),
      Text(subtext),
    ],
  );
}

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
    child: Text(label, style: const TextStyle(fontSize: 20)),
  );
}

Widget goToPage({
  required BuildContext context,
  required String goToText,
  required String routeName,
}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, routeName);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          goToText,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const Icon(Icons.arrow_forward),
      ],
    ),
  );
}

Widget displayCard({
  required BuildContext context,
  required String title,
  required String amount,
  required String goToText,
  required String appRoute,
  Color backgroundColor = const Color(0xFFFDE7D3),
  IconData icon = Icons.trending_up,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(16),
    ),
    child: Container(
      height: 150,
      width: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon),
            ],
          ),
          SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          goToPage(context: context, goToText: goToText, routeName: appRoute),
        ],
      ),
    ),
  );
}

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

