import 'package:flutter/material.dart';
import 'package:todo_app_getx/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  //final Function onTap;

  const MyButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => onTap,
      onTap: onTap,
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(20),
        ),
        child:
            Center(child: Text(label, style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
