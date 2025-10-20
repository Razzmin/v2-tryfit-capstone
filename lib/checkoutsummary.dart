import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tryfit_capstone/category_products.dart';

class Checkoutsummary extends StatefulWidget {
  final double total; //total price
  const Checkoutsummary({super.key, required this.total});

  @override
  State<Checkoutsummary> createState() => _CheckoutsummaryState();
}

class _CheckoutsummaryState extends State<Checkoutsummary> 
 with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController( //ac controls the animation
      duration: const Duration(milliseconds: 600),
      vsync: this, 
      );
    
    //to rotate: tween
    _animation = Tween<double>(begin: -0.1, end: 0.1).animate(CurvedAnimation(parent: _controller, 
    curve: Curves.easeInOut),
    );
  
  
  //repeat
  _controller.repeat(reverse: true);
  Future.delayed(Duration(seconds: 2), () {
    if (mounted) {
    _controller.stop(); 
    }// will move 2 sec tas stop na
  });
   }
  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 150),

            //bell
            AnimatedBuilder(animation: _animation,
             builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value, //rotates the bell
                child: child,
                );
             },
             child: Icon(
              Icons.notifications_active_rounded,
              size: 80,
              color: Color(0xFF9747FF),
             ),
             ),

            //order completed text and id
            const SizedBox(height: 20),
            const Text(
              "Order Completed!",
              style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Order id: #110V3U",
              style: TextStyle(fontSize: 14, color: Colors.grey), //later put orders in firebase, para lumabas dito yung order id
            ),
            const SizedBox(height: 70),


            //summary section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                summaryRow("Order", widget.total),
                summaryRow("Delivery", 58),
                summaryRow("Total", widget.total + 58, isBold: true),
              ],
             ),
              ),

              const SizedBox(height: 40),

              //continue shopping button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CategoryProducts()),
                  ); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const  Color(0xFF9747FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12)),
                    ),
                 
                  child: const Text(
                    "Continue Shopping",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white), 
                      ),
                    ),
                  ),
          ],
              ),
              ),
    );
  }

  //helper method for summary rows
  Widget summaryRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
            Text("₱${amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
            )
          );
  }
}