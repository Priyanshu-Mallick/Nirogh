import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:nirogh/Screens/profile_setup.dart';

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
      Fluttertoast.showToast(
        msg: 'Phone OTP successfully Verified',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
      );
      return 1;
    } catch (e) {
      // OTP verification failed
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'Unknown Error occurred while verifying OTP',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
      );
      return 0;
    }
  }
  Future<void> performEmailVerification(BuildContext context, String name, String email, String phone, String password) async {
    try {
      // Perform any additional logic required before Firebase email authentication

      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Perform additional logic after successful signup
      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('User Data').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Successful'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileSetup()),
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
}
