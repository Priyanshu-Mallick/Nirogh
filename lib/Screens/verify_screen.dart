import 'package:flutter/material.dart';
import 'package:nirogh/services/auth_service.dart';

class VerifyScreen extends StatefulWidget {
  final String email;
  final String phoneNumber;

  VerifyScreen({required this.email, required this.phoneNumber});

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final eotpController1 = TextEditingController();
  final eotpController2 = TextEditingController();
  final eotpController3 = TextEditingController();
  final eotpController4 = TextEditingController();
  final eotpController5 = TextEditingController();
  final eotpController6 = TextEditingController();
  final otpController1 = TextEditingController();
  final otpController2 = TextEditingController();
  final otpController3 = TextEditingController();
  final otpController4 = TextEditingController();
  final otpController5 = TextEditingController();
  final otpController6 = TextEditingController();

  bool isEmailVerified = false;
  bool isPhoneVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Screen'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: ${widget.email}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Enter the OTP'),
            const SizedBox(height: 10),
            Row(
              children: [
                for (var i = 0; i < 6; i++)
                  Container(
                    width: 51,
                    height: 51,
                    margin: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: i == 0
                          ? eotpController1
                          : i == 1
                          ? eotpController2
                          : i == 2
                          ? eotpController3
                          : i == 3
                          ? eotpController4
                          : i == 4
                          ? eotpController5
                          : eotpController6,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && i < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: isEmailVerified
                  ? const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              )
                  : TextButton(
                onPressed: () {
                  // Handle OTP verification
                  String otp = eotpController1.text +
                      eotpController2.text +
                      eotpController3.text +
                      eotpController4.text +
                      eotpController5.text +
                      eotpController6.text;
                  if (otp.length == 6) {
                    // Perform OTP verification
                    bool isOTPVerified =
                    AuthService().verifyOTP(otp) as bool; // Assuming AuthService().verifyOTP() returns a boolean indicating the verification status

                    setState(() {
                      isEmailVerified = isOTPVerified;
                    });
                  }
                },
                child: const Text(
                  'Verify',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Phone: ${widget.phoneNumber}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Enter the OTP'),
            const SizedBox(height: 10),
            Row(
              children: [
                for (var i = 0; i < 6; i++)
                  Container(
                    width: 51,
                    height: 51,
                    margin: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: i == 0
                          ? otpController1
                          : i == 1
                          ? otpController2
                          : i == 2
                          ? otpController3
                          : i == 3
                          ? otpController4
                          : i == 4
                          ? otpController5
                          : otpController6,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && i < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: isPhoneVerified
                  ? const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              )
                  : TextButton(
                onPressed: () async {
                  // Handle OTP verification
                  String otp = otpController1.text +
                      otpController2.text +
                      otpController3.text +
                      otpController4.text +
                      otpController5.text +
                      otpController6.text;
                  if (otp.length == 6) {
                    // Perform OTP verification
                    bool verified = await AuthService().verifyOTP(otp); // Assuming AuthService().verifyOTP() returns a boolean indicating the verification status
                    if (verified) {
                      // Perform necessary actions upon successful OTP verification
                    } else {
                      // Handle OTP verification failure
                    }

                  }
                },
                child: const Text(
                  'Verify',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    AuthService().sendOTP(widget.phoneNumber, widget.email); // Call the sendOTP function
                  },
                  child: Text('Send OTP'),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the screen
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
