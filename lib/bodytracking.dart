import 'package:flutter/material.dart';
import 'package:tryfit_capstone/products.dart';
import 'dart:developer' as developer;

class Bodytracking extends StatefulWidget {
  const Bodytracking({super.key});

  @override
  State<Bodytracking> createState() => _BodytrackingState();
}

class _BodytrackingState extends State<Bodytracking> {
  //will show the dialog when screen opens
  @override 
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCameraPermissionDialog();
    });
  }

  void _showCameraPermissionDialog() {
    showDialog(context: context,
    barrierDismissible: false, //user should choose y/n
     builder:(context){
      return AlertDialog(
        title: const Text("Camera Permission"),
        content: const Text(
          "Allow the application to access your camera?"),
          actionsAlignment: MainAxisAlignment.center,
          actions: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(
              width: 100,
              child: ElevatedButton(
              onPressed: () {
              Navigator.pop(context); //handles the permission logic (granted)
              developer.log("Camera Permission Granted");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF9747FF),
              minimumSize: const Size.fromHeight(40),
              foregroundColor: Colors.white,
            ),
            child: const Text("Yes"),
             ),
              ),

              const SizedBox(width: 20),
              SizedBox(
                width: 100,
               child: ElevatedButton(
              onPressed: () {
              Navigator.pop(context); //handles the permission logic (denied)
              developer.log("Camera Permission Denied");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              minimumSize: const Size.fromHeight(40),
              foregroundColor: Colors.white,
            ),
            child: const Text("No"),
             ),
             ),
          ],
      ),
     ],
     );
     }
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
      SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align (
                alignment: Alignment.topLeft,
                 child: Padding(
              padding: const EdgeInsets.only(top:30, left: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.navigate_before,
                    color: Colors.black, 
                    size: 30,
                    ),
                ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text("Please ensure your whole body is visible in the camera for accurate tracking",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black
              ),
              textAlign: TextAlign.center,
             ),
              ),
          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black54,
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Camera Here",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ),
              ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  developer.log("Body Tracking Done");
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Products()),
                  );
                },
                style: ElevatedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF9747FF),
                  ),
                   child: const Text("Confirm",
                   style: TextStyle(fontSize: 18,
                   color: Colors.white
                   ),
                   ),
                  ),
                ),
                ),
                const SizedBox(height: 40),
          ],
            ),
            ),
          ],
        )
        );
  }
}