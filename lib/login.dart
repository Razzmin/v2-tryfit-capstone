import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryfit_capstone/homepage.dart';
import 'package:tryfit_capstone/signup.dart';
import 'dart:developer' as developer;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email= TextEditingController();
  TextEditingController password= TextEditingController();
  bool hidePassword = true;

 signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      developer.log("Login Successful!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } on FirebaseAuthException catch (e) {
      developer.log("FirebaseAuthException: ${e.code} - ${e.message}");
      String message = "";
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with that Email.';
          break;
        case 'wrong-password':
          message = 'Incorrect Password.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later.';
          break;
        default:
          message = 'Login Failed. Please try again.';
      }

      showErrorPopup(message);
    } catch (e) {
      developer.log("Unknown Error: $e");
      showErrorPopup("An unexpected error occurred: $e");
    }
  }

  // 🔹 ERROR POPUP FUNCTION — add this INSIDE the class but OUTSIDE signIn()
  void showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
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
                    "Login",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
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
                //Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF9747FF),
                  ),
                   child: const Text("Login",
                   style: TextStyle(fontSize: 18,
                   color: Colors.white),
                   ),
                  ),
                   ),
                const SizedBox(height: 20),
                //signup link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                       onTap: () {
                        Navigator.push(
                          context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                        );
                        },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color:  Color(0xFF9747FF),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
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
       ],
        ),
    );
  } 
}