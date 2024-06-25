import 'package:flutter/material.dart';
//import 'package:team_proj_leanne/pages/sub_pages/edit_user.dart';
import 'package:team_proj_leanne/pages/widgets/custom_bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //body: EditUser(),
        body: customBottomNavigationBar(initialPageIndex: 0)
      ),
    );
  }
}
