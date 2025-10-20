// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:tryfit_capstone/homepage.dart';
import 'package:tryfit_capstone/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
   // return Scaffold(
   return const Login();

      //body: StreamBuilder(
       //stream: FirebaseAuth.instance.authStateChanges(), 
        //builder: (context, snapshot) {
         // if (snapshot.hasData) {
            //return Homepage();
          //} else {
          // return Login();
       //   }
       // }),
  }
}

// i made some of it as cmmts rn kasi etong wrapper conditional sha, were trying to see pa naman if babalik syang login lagi