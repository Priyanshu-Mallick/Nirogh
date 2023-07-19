import 'package:flutter/material.dart';
import 'package:nirogh/Screens/drawer_content.dart';
import 'package:nirogh/Widgets/bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Home Screen!',
          style: TextStyle(fontSize: 20),
        ),
      ),
      drawer: Drawer(
        child: DrawerContent(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

