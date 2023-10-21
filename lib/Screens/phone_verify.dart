import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirogh/Screens/profile_setup.dart';
import 'package:nirogh/services/auth_service.dart';
import 'package:pinput/pinput.dart';

import 'home_screen.dart';

class MyVerify extends StatefulWidget {
  final String userName;
  final String email;
  final String phoneNumber;
  final String verificationId;
  final String userProfilePic;
  final String selectedAge;
  final String selectedSex;
  final String selectedBlood;

  const MyVerify({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.verificationId,
    required this.userProfilePic,
    required this.selectedAge,
    required this.selectedSex,
    required this.selectedBlood,
  });

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {

  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    String ph = widget.phoneNumber;
    String modifiedPhoneNumber = '';
    if (ph.length >= 10) {
      // Replace the first 8 digits with asterisks
      String asterisks = '*' * 8;
      modifiedPhoneNumber = '$asterisks${ph.substring(ph.length - 2)}';
    } else {
      // If the phone number is less than 10 digits, display it as is
      modifiedPhoneNumber = ph;
    }

    final defaultPinTheme = PinTheme(
      width: screenHeight * 0.08,
      height: screenHeight * 0.08,
      textStyle: TextStyle(
          fontSize: screenHeight * 0.025,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(screenHeight * 0.04),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.cyan),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/Assets/verify.png',
                width: screenWidth * 0.4,
                height: screenHeight * 0.2,
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: screenHeight * 0.035, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                "We need to register your phone before saving your profile!",
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Text(
                "OTP has been sent to +91 $modifiedPhoneNumber",
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,

                showCursor: true,
                onCompleted: (pin) => otpController.text=pin,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenHeight * 0.05),)),
                    onPressed: () async {
                      // Handle verification button press
                      String otp = otpController.text;
                      print("OTP "+otp);
                      if (otp.length == 6) {
                        // Perform OTP verification
                        // You should implement the verification logic in your AuthService
                        int d = await AuthService().verifyPhoneOTP(widget.verificationId, otp);
                        print(d);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Dialog(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20),
                                    Text('Verifying...'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        if (d == 1) {
                          Fluttertoast.showToast(
                            msg: 'OTP verified successfully',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[800],
                            textColor: Colors.white,
                          );
                          AuthService().SaveUserData(widget.email, widget.userName, widget.phoneNumber, widget.selectedAge, widget.selectedSex, widget.selectedBlood);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Incorrect OTP',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[800],
                            textColor: Colors.white,
                          );
                          print("Error");
                        }

                        // Clear the OTP field
                        otpController.clear();
                      }
                    },
                    child: const Text("Verify Phone Number", style: TextStyle(color: Colors.white),)),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UpdateProfileScreen(email: widget.email, userProfilePic: widget.userProfilePic, userName: widget.userName)),
                        );
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black, fontSize: screenHeight * 0.015),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}