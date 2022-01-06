import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx/ui/theme.dart';

class MyInputNoteField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? textController;
  final Widget? widget;

  const MyInputNoteField(
      {required this.title,
      required this.hint,
      this.textController,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          Container(
            height: 80,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    controller: textController,
                    style: subtitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subtitleStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.backgroundColor, width: 0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.backgroundColor, width: 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
