import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;
  final double cashDue;

  BookingConfirmationScreen({required this.bookingId, required this.cashDue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Appointment Booked",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 300.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Booking ID: $bookingId",
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Cash due: $cashDue",
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Allocating Phlebotomist",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),
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
              child: const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
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
