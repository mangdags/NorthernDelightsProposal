import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:northern_delights_app/screens/home_screen.dart';

import 'models/foodplace_doc_data.dart';


GastropubDocData foodPlaceDocData = GastropubDocData();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Northern Delights',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: HomeScreen(),
      initialRoute: 'home_screen',
       routes: {
         'home_screen': (context) => HomeScreen(),
       }
    );
  }
}
