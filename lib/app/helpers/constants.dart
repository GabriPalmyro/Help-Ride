import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final Future<FirebaseApp> initialization = Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "AIzaSyCmEFTMdD2Qcdj5zVbo9kFRzYsFYOgANQM",
    authDomain: "help-ride-63230.firebaseapp.com",
    projectId: "help-ride-63230",
    storageBucket: "help-ride-63230.appspot.com",
    messagingSenderId: "706029459731",
    appId: "1:706029459731:web:3186ca4c88bab52ff8e2e6",
  ),
);

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
