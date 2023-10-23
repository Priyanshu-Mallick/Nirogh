import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:nirogh/Screens/home_screen.dart';
import 'package:nirogh/Screens/profile_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  bool isOTPSent = false; // Add this variable to track whether OTP has been sent
  FirebaseAuth auth = FirebaseAuth.instance; // Declare the auth variable outside the sendOTP method
  String? verificationId;
  int otp=0;
  // final eotpController1 = TextEditingController();
  // final eotpController2 = TextEditingController();
  // final eotpController3 = TextEditingController();
  // final eotpController4 = TextEditingController();
  // final eotpController5 = TextEditingController();
  // final eotpController6 = TextEditingController();
  final otpController1 = TextEditingController();
  final otpController2 = TextEditingController();
  final otpController3 = TextEditingController();
  final otpController4 = TextEditingController();
  final otpController5 = TextEditingController();
  final otpController6 = TextEditingController();

  // bool emailVerificationSuccess = false;
  bool phoneVerificationSuccess = false;

  // Function for Google Sign-In
  // Function for Google Sign-In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Configure GoogleSignIn with the required scopes
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );

      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser != null) {
        // Obtain auth details from request
        final GoogleSignInAuthentication gAuth = await gUser.authentication;

        // Create a new credential for the user
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        // Finally, let's sign in
        final authResult = await FirebaseAuth.instance.signInWithCredential(credential);

        // If the sign-in is successful, retrieve and pass user data to UpdateProfileScreen
        if (authResult.user != null) {
          final user = authResult.user!;
          AuthService.setLoggedIn(true);
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => UpdateProfileScreen(
                email: user.email ?? "",
                userProfilePic: user.photoURL ?? "",
                userName: user.displayName ?? "",
                uid: user.uid,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors that occur during sign-in
      print("Error during sign-in: $e");
    }
  }

  Future<void> SaveUserData(String uid, String email, String userName, String phoneNumber, String selectedAge, String selectedSex, String selectedBlood) async {

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> userData = {
          'uid': uid,
          'name': userName,
          'email': email,
          'phone': phoneNumber,
          'age': selectedAge,
          'blood_grp': selectedBlood,
          'gender': selectedSex,
        };

        // Convert userData to a JSON string
        String jsonData = json.encode(userData);
        print(jsonData);

        // Send a POST request to your backend API
        final response = await http.post(
          Uri.parse("https://43.204.149.138/api/user/"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonData,
        );

        if (response.statusCode == 200) {
          print('User data saved successfully');
        } else {
          print('Failed to save user data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }


  String _generateOTP(int length) {
    // Generate a random OTP
    final Random random = Random();
    const String chars = '0123456789';
    String otp = '';

    for (int i = 0; i < length; i++) {
      otp += chars[random.nextInt(chars.length)];
    }

    return otp;
  }

  Future<String> sendOTPToEmail(String email) async {
    // Generate a random 6-digit OTP
    String otp = _generateOTP(6);

    // Send OTP to email
    String username = 'niroghcare@gmail.com'; // Replace with your email address
    String password = 'telkysvrewcbwkfk'; // Replace with your email password

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(email)
      ..subject = 'OTP for Verification'
      ..text = 'Your OTP for verification: $otp';

    try {
      send(message, smtpServer);

      // Show the toast message
      Fluttertoast.showToast(
        msg: 'OTP sent successfully to email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
      );
    } catch (e) {
      // Handle OTP send failure
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'Unknown Error occurred while sending OTP',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
      );
    }

    return otp;
  }

  Future<String> sendOTPToPhone(String phoneNumber) async {
    Completer<String> completer = Completer<String>(); // Create a Completer

    String verificationID;
    await auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (credential) async {
          await auth.signInWithCredential(credential);
        },
        codeSent: (verificationId, resendToken) {
          verificationID = verificationId;
          Fluttertoast.showToast(
            msg: 'OTP sent successfully to phone number',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
          );
          completer.complete(verificationID);
        },
        codeAutoRetrievalTimeout: (verificationId){
          // verificationID = verificationId;
        },
        verificationFailed: (e){
          print("Failed to send code ${e.message}");
          Fluttertoast.showToast(
            msg: 'Unknown Error occurred while sending OTP',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
          );
          completer.completeError(e);
        }
    );
    return completer.future; // Return the future from the completer
  }

  Future<int> verifyEmailOTP(String emailOTP, String enteredOTP) async {
    if (emailOTP == enteredOTP) {
      // OTP verification successful
      return 1;
    } else {
      // OTP verification failed
      return 0;
    }
  }

  Future<int> verifyPhoneOTP(String verificationId, String enteredOTP) async {
    print(enteredOTP);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: enteredOTP,
    );

    try {
      await auth.signInWithCredential(credential);
      // OTP verification successful
      // Fluttertoast.showToast(
      //   msg: 'Phone OTP successfully Verified',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.grey[800],
      //   textColor: Colors.white,
      // );
      return 1;
    } catch (e) {
      // OTP verification failed
      print(e.toString());
      // Fluttertoast.showToast(
      //   msg: 'Unknown Error occurred while verifying OTP',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.grey[800],
      //   textColor: Colors.white,
      // );
      return 0;
    }
  }
  Future<void> performEmailVerification(BuildContext context, String name, String email, String password) async {
    try {
      // Perform any additional logic required before Firebase email authentication

      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid; // Get the UID of the newly created user

      await SaveUserData(
        uid,
        email,
        name,
        "",
        "", //age
        "", //sex
        "", //bloodgroup
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Successful'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  setLoggedIn(true);
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateProfileScreen(email: email, userName: name, userProfilePic: "", uid: "",)),
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  Future<void> showResetPasswordBottomSheet(BuildContext context) async {
    TextEditingController emailController = TextEditingController();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double sheetHeight = screenHeight * 0.72;
    double buttonWidth = screenWidth * 0.4;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: sheetHeight,
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter the registered email',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.03,
                          horizontal: buttonWidth * 0.3,
                        ),
                        minimumSize: Size(buttonWidth, 0),
                      ),
                      onPressed: () {
                        String email = emailController.text.trim();

                        if (email.isNotEmpty) {
                          FirebaseAuth.instance.sendPasswordResetEmail(email: email)
                              .then((value) {
                            // Password reset email sent successfully
                            // Provide feedback to the user if needed
                            Fluttertoast.showToast(
                              msg: 'Check email for password reset link',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[800],
                              textColor: Colors.white,
                            );
                            Navigator.of(context).pop();
                          }).catchError((error) {
                            // Handle any errors that occurred during the password reset process
                            // Provide feedback to the user if needed
                            print('Password reset error: $error');
                          });
                        } else {
                          // Provide feedback to the user that email field is empty
                          Fluttertoast.showToast(
                            msg: 'Please enter your email',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[800],
                            textColor: Colors.white,
                          );
                        }
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        side: const BorderSide(
                          color: Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.03,
                          horizontal: buttonWidth * 0.3,
                        ),
                        minimumSize: Size(buttonWidth, 0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await setLoggedIn(false);
  }
  Future<bool> checkIfPhoneNumberRegistered(String phoneNumber) async {
    try {
      // Use Firebase authentication API to check if the phone number is registered
      String phno='+91$phoneNumber';
      final result = await FirebaseAuth.instance.signInWithPhoneNumber(phno);

      // If signInWithPhoneNumber is successful, it means the phone number is registered
      return true;
    } catch (e) {
      // If an error occurs, it means the phone number is not registered
      return false;
    }
  }
}
