import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tryfit_capstone/login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key}); 
  
  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {

 final user = FirebaseAuth.instance.currentUser;

signout() async {
    await FirebaseAuth.instance.signOut();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text("Homepage"),
      ),
    body: Center(
      child: Text(user?.email ?? "No user logged in"),
    ),
    floatingActionButton: FloatingActionButton(
     onPressed: () async {
    await FirebaseAuth.instance.signOut();

    // Navigate to Login screen after signing out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  },
  child: const Icon(Icons.login_rounded),
  ),
);
  }
}