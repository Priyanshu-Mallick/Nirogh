import 'package:flutter/material.dart';

class CallUsCard extends StatelessWidget {
  const CallUsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(top: 12, bottom:8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("You are not sure about your health? ", style: TextStyle(fontSize: 13, color: Colors.black),),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Set the corner radius to 30
              ),
              primary: Colors.black, // Set button color to black
            ),
            child: Text(
              "Call Us",
              style: TextStyle(
                color: Colors.white, // Set text color to white
              ),
            ),
          )

        ],
      ),
    );
  }
}
