import 'package:flutter/material.dart';
import 'package:nirogh/Screens/home_screen.dart';

class ProfileSetup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.cyanAccent,
        body: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: const [
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.blue,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                      border: Border.all(color: Colors.black, width: 1.5), // Border line
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                suffixStyle: TextStyle(fontSize: 20),
                              ),
                              style: TextStyle(fontSize: 22),
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                suffixStyle: TextStyle(fontSize: 20),
                              ),
                              style: TextStyle(fontSize: 22),
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Age',
                                suffixStyle: TextStyle(fontSize: 20),
                              ),
                              style: TextStyle(fontSize: 22),
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Sex',
                                suffixStyle: TextStyle(fontSize: 20),
                              ),
                              style: TextStyle(fontSize: 22),
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Blood Group',
                                suffixStyle: TextStyle(fontSize: 20),
                              ),
                              style: TextStyle(fontSize: 22),
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                suffixStyle: TextStyle(fontSize: 20),
                              ),
                              style: TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Perform save action
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyanAccent,
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ],
                        )
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
