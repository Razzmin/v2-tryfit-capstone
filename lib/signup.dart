import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryfit_capstone/login.dart';
import 'package:tryfit_capstone/bodymeasurement.dart';
import 'dart:developer' as developer;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email= TextEditingController();
  final TextEditingController password= TextEditingController();
  bool hidePassword = true;

  
  signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
         password: password.text
         );
         developer.log("Signup Successful!");

         //navigate to body measurement screen
         Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context)=> Bodymeasurement()),
          );
          //catches error  firebase related
    } on FirebaseAuthException catch (e) {
      developer.log("Sign Up Failed: ${e.code} - ${e.message} ");
      String message ="";
      switch (e.code) {
      case 'email-already-used':
      message = 'This email is already used.';
      break;
      case 'weak-password':
      message = 'Password should be at least 6 characters.';
      break;
      case 'invalid-email':
      message = 'Please enter a valid email address.';
      break;
      default:
      message = 'Sign Up Failed. Please try again';
    }
    //catch error system related
    showErrorPopup(message);
    } catch (e) {
      developer.log("Error: $e");
      showErrorPopup("An unexpected error occurred.");
    }
    } 

   //pop up message -- if may mali sa in-input
  void showErrorPopup (String message) {
    showDialog(context: context, 
    builder: (context) => AlertDialog(
      title: const Text("Sign Up Failed"),
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
         //login form
        Center (
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 10),
                //login link
                Row(
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                        MaterialPageRoute(builder: (context) => const Login()),
                        );
                        },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color:  Color(0xFF9747FF),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                  const SizedBox(height: 30),
                TextField(
                  controller:  username,
                  decoration: InputDecoration(
                    hintText: 'Enter Username',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

              const SizedBox(height: 30),
                TextField(
                  controller: password,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                       hidePassword ? Icons.visibility_off : Icons.visibility, 
                   ),
                   onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                   },
                    ),
                  ),
                ),
                const SizedBox(height:40),
                //Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                     onPressed: () {
                  developer.log("test");
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Bodymeasurement()),
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
