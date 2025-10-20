import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:tryfit_capstone/wrapper.dart';
import 'dart:developer' as developer;

void main () async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  developer.log('Firebase Successful');
  } catch (e) {
  developer.log('Firebase failed');
  }

  //sign out for testing
  await FirebaseAuth.instance.signOut;
  
  runApp( const MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
      );
  }
}