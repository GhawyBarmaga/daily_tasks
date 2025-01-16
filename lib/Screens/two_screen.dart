import 'package:daily_tasks/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class TwoScreen extends StatelessWidget {
  const TwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('f5f5dc'),
        elevation: 0,
      ),
      backgroundColor: HexColor('f5f5dc'),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
                "Are you looking for an easy and effective way to organize your day and increase your productivity?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text(
                "Simple and practical design: Convenient and easy-to-use user interface for all categories.",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/2.png',
              width: Get.width * 0.9,
              height: Get.height * 0.5,
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const TasksScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      )),
    );
  }
}
