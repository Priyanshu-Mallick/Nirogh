import 'package:flutter/material.dart';

class PaidBookingConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final double cashDue;

  PaidBookingConfirmationScreen({required this.bookingId, required this.cashDue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Successfull",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 300.0,
            ),
            SizedBox(height: 16.0),
            Text(
              "Booking ID: $bookingId",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                "Phlebotomist is on the way to collect your sample",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center the text horizontally.
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                // Implement your tracking logic here.
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
                child: Text(
                  "Track",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
