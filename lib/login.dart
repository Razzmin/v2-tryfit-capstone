import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isLoading = false; 

    Future<void> signIn() async {
      
      if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
        showErrorPopup("Please enter both email and password.");
        return;
      }

      setState(() => isLoading = true); 

      try {
        //user sign in
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim()
        );

        final User? user = userCredential.user;

        if (user != null) {
          final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
          
          final DocumentSnapshot<Map<String, dynamic>> userDoc = 
          await docRef.get(); 

          if (userDoc.exists) {
            developer.log("User Firestore data: ${userDoc.data()}");
          } else {
            developer.log("No Firestore data found for this user.");
            showErrorPopup("Logged in, but user profile data not found.");
            setState(() => isLoading = false);
          }
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
          );
      } on FirebaseAuthException catch (e) {
        developer.log("FirebaseAuthException: ${e.code} - ${e.message}");
        String message;
        switch (e.code) {
        case 'user-not-found':
        case 'auth/user-not-found':
          message = 'No user found with that Email.';
          break;
        case 'wrong-password':
        case 'auth/wrong-password':
          message = 'Incorrect Password.';
          break;
        case 'invalid-email':
        case 'auth/invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'invalid-credential':
        case 'auth/invalid-credential':
          message = 'Invalid email or password.';
          break;
        case 'too-many-requests':
        case 'auth/too-many-requests':
          message = 'Too many attempts. Try again later.';
          break; 
        case 'network-request-failed':
        case 'auth/network-request-failed':
          message = 'Network error.Check your connection.';
          break;
         default:
          message = 'Login Failed. Please try again.';
        }
        showErrorPopup(message);
      } catch (e) {
      developer.log("Unknown Error during sign-in: $e");
      showErrorPopup("An unexpected error occurred: $e");
    } finally {
      if(mounted) setState(() => isLoading = false);  
      }
    }

    //alert dialog para alam ni user saan may mali
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
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
       children: [
        //bg image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: 
            AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
            ),
          ),
        ),
        
        //Main content (login form)
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

              //password label n input
            const SizedBox(height: 10),
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
                    setState(() =>
                      hidePassword = !hidePassword);
                    },
                    ),
                  ),
                ),
                ],
                ),


                const SizedBox(height:40),

                //login button 
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signIn,
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

           //overlay if nagloloading pa sya 
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
}