import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;
import 'package:tryfit_capstone/bodytracking.dart';
import 'package:tryfit_capstone/signup.dart';



class Bodymeasurement extends StatefulWidget {
  const Bodymeasurement({super.key});

  @override
  State<Bodymeasurement> createState() => _BodymeasurementState();
}

class _BodymeasurementState extends State<Bodymeasurement> {
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController waist = TextEditingController();
  bool showPopup = false;

  // save measurements to database
  saveMeasurements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showErrorPopup('You must be logged in.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('measurements').add({
        'height' : height.text,
        'weight' : weight.text,
        'waist' : waist.text,
        'userId' : user.uid,
      });
      setState(() {
        showPopup = true;
      });
    } catch (e) {
      showErrorPopup('Something went wrong while saving your data');
     developer.log('Error saving measurements: $e');
    }
  }
  //pop up message -- if may mali sa in-input
  void showErrorPopup (String message) {
    showDialog(context: context, 
    builder: (context) => AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text ("OK"),
        )
      ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
       children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: 
            AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
            ),
          ),
        ),
         
         SafeArea (
            child: Align(
              alignment: Alignment.topLeft,
             child: Padding(
              padding: const EdgeInsets.only(top:30, left: 20),
                 child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed:() =>  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Signup()),
                  ),
                        ), 
                        ),
                        )
              ),

          Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox( height: 40),
                      const Text(
                        "Body Measurements",
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Monteserrat' 
                        ),
                      ),


                  const SizedBox(height: 20),

                  TextField(
                  controller: height,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter your height in (cm)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                      ), 
                  ),

                   const SizedBox(height: 20),

                    TextField(
                    controller: weight,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                    hintText: "Enter your weight in (kg)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                    ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ), 
                ), 

                  const SizedBox(height: 20),

                    TextField(
                    controller: waist,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                    hintText: "Enter your waist in (cm)",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                    ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                   ),
                ), 
                  
                const SizedBox(height:40),

                //Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () {
                  developer.log("test");
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Bodytracking()),
                  );
                },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF9747FF),
                  ),
                   child: const Text("Next",
                   style: TextStyle(fontSize: 18,
                   color: Colors.white),
                   ),
                  ),
                ),
       ],  
                  ),
            ),
              ),
               ),      
            ],
           ), 
     );
  }
}