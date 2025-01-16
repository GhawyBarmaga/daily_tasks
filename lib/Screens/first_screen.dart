import 'package:daily_tasks/Screens/two_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class OneScreen extends StatefulWidget {
  const OneScreen({super.key});

  @override
  State<OneScreen> createState() => _OneScreenState();
}

class _OneScreenState extends State<OneScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 7), () {
      Get.off(() => const TwoScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('f5f5dc'),
        elevation: 0,
      ),
      backgroundColor: HexColor('f5f5dc'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Welcome to Daily Tasks App",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("Your personal task management app",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/1.png',
              width: Get.width,
              height: Get.height * 8 / 10,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
