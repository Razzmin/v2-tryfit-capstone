import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryfit_capstone/login.dart';
import 'package:tryfit_capstone/bodymeasurement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isLoading = false;

  Future<void> signUp() async {
     if ( username.text.trim().isEmpty || email.text.trim().isEmpty || password.text.trim().isEmpty) {
        showErrorPopup("Please fill all fields before continuing.");
        return;
      }

      setState(() => isLoading = true); 

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim()
         );

         final User? user = userCredential.user;

        if (user != null) {
          final userId = FirebaseFirestore.instance.collection('tmp').doc().id;

          
          //saves user info to database
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'username': username.text.trim(),
            'email' : email.text.trim(),
            'userId' : userId,
            'createdAt' : FieldValue.serverTimestamp(),
          });

          developer.log("User created successfully and recorded to firestore");
         
         //navigate to body measurement screen
         if (mounted) {
         Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context)=> Bodymeasurement()),
          );
          }
        }
        //deals with signup errors
    } on FirebaseAuthException catch (e) { 
      developer.log("Firebase Sign Up Error: ${e.code} - ${e.message} ");
      String message;

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
      case 'network-request-failed':
      message = 'Network error. Please check your internet.';
      break;
      default:
      message = 'Something went wrong. Please try again';
    }

    showErrorPopup(message);
    } catch (e) {
      developer.log("Unexpected error: $e");
      showErrorPopup("An unexpected error occurred.");
    } finally {
       if (mounted) setState(() => isLoading = false);
    }
    } 

   //pop up messages for errors
  void showErrorPopup (String message) {
    showDialog(context: context, 
    builder: (context) => AlertDialog(
      title: const Text("Sign Up Message"),
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
         
         
         //main content (signup form)
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

                //username label n inputbox
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Username:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  const SizedBox(height: 10),
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
                  ],
                ),
                const SizedBox(height: 10),

                //email label n inputbox
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                 const SizedBox(height: 10),    
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
                  ],
                 ),
              const SizedBox(height: 10),

                //password label n inputbox
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                 const SizedBox(height: 10), 
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
                    setState (() =>
                      hidePassword = !hidePassword);
                    },
                    ),
                  ),
                    ),

                const SizedBox(height:30),

                //Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                    onPressed: isLoading ? null : signUp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color(0xFF9747FF),
                    ),
                    child: const Text("Next",
                    style: TextStyle(fontSize: 18,
                    color: Colors.white),
                    ),
                  ),
                ),
                  ],
                 ),
                ],
                   ),
          ),
          ),
        ),
          if (isLoading)
           Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF9747FF)),
              ),
              ), 
              ),
              ],
           ),
           );
           }      
    @override 
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
