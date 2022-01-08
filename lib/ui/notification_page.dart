import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  final String? label;

  NotificationPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Get.isDarkMode ? Colors.grey[600] : Colors.white,
          ),
          child: Center(
            child: Text(
              this.label.toString().split("|")[1],
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom AppBar
  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      //backgroundColor: context.theme.backgroundColor,
      backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios),
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      title: Text(
        this.label.toString().split("|")[0],
        style: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
