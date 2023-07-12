import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AuthService {
  bool isOTPSent = false; // Add this variable to track whether OTP has been sent
  FirebaseAuth auth = FirebaseAuth.instance; // Declare the auth variable outside the sendOTP method
  String? verificationId;
  int otp=0;
  signInWithGoogle() async {
    // begin interactive sign-in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for the user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, let's sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<String?> getUserDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.displayName;
    }
    return null;
  }

  Future<String> getUniqueUsername(String displayName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        return snapshot.data()!['username'];
      } else {
        final username = await generateUniqueUsername(displayName);
        await storeUserDisplayName(displayName, username);
        return username;
      }
    }
    throw Exception('User is not signed in.');
  }

  Future<String> generateUniqueUsername(String displayName) async {
    final random = Random();
    final prefix = displayName.replaceAll(' ', '').toLowerCase();
    final suffix = random.nextInt(9999).toString().padLeft(4, '0');
    final username = '$prefix$suffix';
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
        .get();
    if (snapshot.docs.isEmpty) {
      return username;
    } else {
      return generateUniqueUsername(displayName); // Recursively generate a new username if it already exists
    }
  }

  Future<void> storeUserDisplayName(String displayName, String username) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
      await userRef.set({
        'displayName': displayName,
        'username': username,
      });
    }
  }
  Future<Map<String, dynamic>> sendOTP(String phoneNumber, String email) async {
    Map<String, dynamic> otpData = {
      'emailOTP': 0,
      'phoneVerificationId': '',
    };
    if (!isOTPSent) {
      // Generate a random 4-digit OTP for email
      Random random = Random();
      int emailOTP = random.nextInt(900000) + 100000;
      otpData['emailOTP'] = emailOTP;

      // Send OTP to phone number
      await auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {
          auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          Fluttertoast.showToast(
            msg: 'Unknown Error occurred while sending OTP',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          otpData['phoneVerificationId'] = verificationId;
          // Store the verification ID
          Fluttertoast.showToast(
            msg: 'OTP sent successfully to phone number',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          otpData['phoneVerificationId'] = verificationId;
        },
      );

      // Send OTP to email
      String username = 'niroghcare@gmail.com'; // Replace with your email address
      String password = 'telkysvrewcbwkfk'; // Replace with your email password

      final smtpServer = gmail(username, password);
      final message = Message()
        ..from = Address(username)
        ..recipients.add(email)
        ..subject = 'OTP for Verification'
        ..text = 'Your OTP for verification: $emailOTP';

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
          msg: 'Unknown Error occure while sending OTP',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
          textColor: Colors.white,
        );
      }
      isOTPSent = true; // Update the OTP sent status
    }
    return otpData;
  }

  // Future<bool> verifyOTP(String otp) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     try {
  //       // Create a PhoneAuthCredential with the verification ID and the entered OTP
  //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId!, // Use the stored verification ID
  //         smsCode: otp,
  //       );
  //
  //       // Sign in the user with the credential
  //       await auth.signInWithCredential(credential);
  //
  //       // Show the toast message
  //       Fluttertoast.showToast(
  //         msg: 'OTP verified successfully',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.grey[800],
  //         textColor: Colors.white,
  //       );
  //
  //       return true; // OTP verification successful
  //     } catch (e) {
  //       // Handle OTP verification failure
  //       print(e.toString());
  //       Fluttertoast.showToast(
  //         msg: 'Invalid OTP',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.grey[800],
  //         textColor: Colors.white,
  //       );
  //
  //       return false; // OTP verification failed
  //     }
  //   } else {
  //     throw Exception('User is not signed in.');
  //   }
  // }
  int verifyOTP(String OTP, int otp){
    int totp = int.parse(OTP);
    if(otp==totp){
      return 1;
    }
    return 0;
  }

  Future<int> verifyPOTP(String OTP, String verificationId) async {
    print(OTP);
    print(verificationId);
    int totp = int.parse(OTP);
    if (OTP.length == 6) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: OTP,
        );
        await auth.signInWithCredential(credential);
        return 1;
      } catch (e) {
        print(e.toString()); // Handle phone OTP verification failure
      }
    }
    return 0;
  }

// void _performFirebaseAuthentication(String email, String phoneNumber) async {
//   try {
//     // Perform any additional logic required before Firebase email authentication
//
//     UserCredential userCredential =
//     await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//
//     // Perform additional logic after successful signup
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Registration Successful'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   } catch (e) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(e.toString()),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
}
