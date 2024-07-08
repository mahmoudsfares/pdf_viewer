import 'package:flutter/material.dart';
import 'package:pdf_sample/data/database/app_db.dart';
import 'package:pdf_sample/pages/landing/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.setInstance(await $FloorAppDatabase.databaseBuilder('app_db.db').build());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter PDF View', debugShowCheckedModeBanner: false, home: LandingPage());
  }
}
