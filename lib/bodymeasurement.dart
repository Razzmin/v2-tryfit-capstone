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
  String? docId; // for update, stores firestore docu id, if nageexist na sha

  @override
  void initState() {
    super.initState();
    fetchExistingMeasurements();
  }

  // kukunin user saved measurement from firestore
  Future<void> fetchExistingMeasurements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
  
  //look for measurement field where userid = current user
    try{
      final querySnapshot = await FirebaseFirestore.instance.collection('measurements').
      where('userId', isEqualTo: user.uid).get();

      if(querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        docId = doc.id; //saves id for updating 
        final data = doc.data();

        height.text = data['height'] ?? '';
        weight.text = data['weight'] ?? '';
        waist.text = data['waist'] ?? '';
      }
    } catch (e) {
      developer.log('Error fetching measurements: $e');
    }
    }

    Future<void> saveMeasurement() async {
    final user = FirebaseAuth.instance.currentUser;
    
     if (user == null) {
      showErrorPopup('You must be logged in');
      return;
     }

    try {
      //data to save
      final measurementData = {
        'height' : height.text,
        'weight' : weight.text,
        'waist' : waist.text,
        'userId' : user.uid,
        'updatedAt' : FieldValue.serverTimestamp(),
      };

      if(docId != null) {
        await FirebaseFirestore.instance.
        collection('measurements').doc(docId).
        set(measurementData, SetOptions(merge: true));
        developer.log('Updated existing measurement');
      } else {
        final newDoc = await FirebaseFirestore.instance.
        collection('measurements').add(measurementData);
        docId = newDoc.id;
        developer.log('Created new measurement');
      }
      //show up confirm to save
      setState(() {
        showPopup = true;
      });
    } catch (e) {
      showErrorPopup('Something went wrong while saving your data');
     developer.log('Error saving measurements: $e');
    }
  }
  //error pop up if may error 
  void showErrorPopup (String message) {
    showDialog(context: context, 
    builder: (context) => AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), 
        child: const Text ("OK"),
        )
      ],
    ),
    );
  }

//dispose
 @override 
 void dispose() {
  height.dispose();
  weight.dispose();
  waist.dispose();
  super.dispose();
 }
   Widget buildInput(String label, String hint, TextEditingController controller) {
      return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  const SizedBox(height: 10),
                  TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: hint,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                      ), 
                  ),
                   const SizedBox(height: 10),
               ],
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
                        icon: const Icon(Icons.navigate_before, color: Colors.black),
                        iconSize: 30,
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
                    const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Enter your measurement details",
                      style: TextStyle(color:  Color.fromARGB(255, 112, 52, 191)),
                    ),
                  ],
                ),
                  const SizedBox(height: 20),

                //height input
                buildInput("Height:", "Enter your height in (cm)", height),
                buildInput("Weight:", "Enter your weight in (kg)", weight),
                buildInput("Waist:", "Enter your waist in (cm)", waist),
                
                const SizedBox(height:30),

                //Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () async {
                  await saveMeasurement(); 
                  if (!mounted) return;
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