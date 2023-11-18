import 'package:flutter/material.dart';

class LoadDialogBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double wsize = MediaQuery.of(context).size.width * 0; // Set the desired size for the square dialog
    final double hsize = MediaQuery.of(context).size.width * 0.3; // Set the desired size for the square dialog

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners for square dialog
      ),
      child: SizedBox(
        width: wsize,
        height: hsize,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.cyan,), // Circular progress indicator
            SizedBox(height: 20),
            Text(
              'Please Wait...',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
