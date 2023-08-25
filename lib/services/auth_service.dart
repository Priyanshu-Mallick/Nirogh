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
import 'package:nirogh/Screens/home_screen.dart';
import 'package:nirogh/Screens/profile_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          'https://www.googleapis.com/auth/contacts.readonly', // Request read-only access to user's contacts
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
            MaterialPageRoute(
              builder: (context) => UpdateProfileScreen(
                email: user.email ?? "",
                userProfilePic: user.photoURL ?? "",
                userName: user.displayName ?? "",
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors that occur during sign-in
      print("Error during sign-in: $e");
    }
  }

  // signInWithGoogle() async {
  //   // begin interactive sign-in process
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  //
  //   // obtain auth details from request
  //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;
  //
  //   // create a new credential for the user
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: gAuth.accessToken,
  //     idToken: gAuth.idToken,
  //   );
  //
  //   // finally, let's sign in
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
  //
  // Future<String?> getUserDisplayName() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     return user.displayName;
  //   }
  //   return null;
  // }

  // Future<String> getUniqueUsername(String displayName) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(user.uid)
  //         .get();
  //     if (snapshot.exists) {
  //       return snapshot.data()!['username'];
  //     } else {
  //       final username = await generateUniqueUsername(displayName);
  //       await storeUserDisplayName(displayName, username);
  //       return username;
  //     }
  //   }
  //   throw Exception('User is not signed in.');
  // }

  // Future<String> generateUniqueUsername(String displayName) async {
  //   final random = Random();
  //   final prefix = displayName.replaceAll(' ', '').toLowerCase();
  //   final suffix = random.nextInt(9999).toString().padLeft(4, '0');
  //   final username = '$prefix$suffix';
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('user')
  //       .where('username', isEqualTo: username)
  //       .get();
  //   if (snapshot.docs.isEmpty) {
  //     return username;
  //   } else {
  //     return generateUniqueUsername(displayName); // Recursively generate a new username if it already exists
  //   }
  // }

  // Function to store user data
  // Future<void> storeUserData(
  //     String profilePictureUrl,
  //     String fullName,
  //     String phoneNumber,
  //     String email,
  //     String age,
  //     String sex,
  //     ) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
  //     await userRef.set({
  //       'profilePictureUrl': profilePictureUrl,
  //       'fullName': fullName,
  //       'phoneNumber': phoneNumber,
  //       'email': email,
  //       'age': age,
  //       'sex': sex,
  //     });
  //     Fluttertoast.showToast(
  //       msg: 'User data saved successfully',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.grey[800],
  //       textColor: Colors.white,
  //     );
  //   }
  //   Fluttertoast.showToast(
  //     msg: 'User data can not stored successfully',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.grey[800],
  //     textColor: Colors.white,
  //   );
  // }

  Future<void> SaveUserData(String email, String userProfilePic, String userName, String phoneNumber, String selectedAge, String selectedSex, String selectedBlood) async {

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> userData = {
          'profilePictureUrl': userProfilePic,
          'email' : email,
          'fullName': userName,
          'phoneNumber': phoneNumber,
          'age': selectedAge,
          'sex': selectedSex,
          'bloodGroup': selectedBlood,
        };
        final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
        if (await userRef.get().then((snapshot) => snapshot.exists)) {
          await userRef.update(userData);
        } else {
          await userRef.set(userData);
        }
        print('User data saved successfully');
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

      await SaveUserData(
        email,
        userCredential.user!.photoURL ?? "",
        name,
        phone,
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
                    MaterialPageRoute(builder: (context) => UpdateProfileScreen(email: "", userName: "", userProfilePic: "")),
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
    double sheetHeight = MediaQuery.of(context).size.height * 0.72;
    double buttonWidth = MediaQuery.of(context).size.width * 0.4;

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
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter the registered email',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
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
                    const SizedBox(width: 16),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        side: const BorderSide(
                          color: Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
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

  Future<void> showVerifyDialog(String name, String email, String phoneNumber, String password, String verificationId, BuildContext context, String dp, String age, String sex, String bg, int c) async {
    double sheetHeight = MediaQuery.of(context).size.height * 0.5;
    double initialPosition = sheetHeight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  sheetHeight -= details.delta.dy;
                });
              },
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  Navigator.pop(context);
                } else if (sheetHeight < initialPosition) {
                  setState(() {
                    sheetHeight = initialPosition;
                  });
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: sheetHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Text(
                        //   'Email ID',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 18,
                        //   ),
                        // ),
                        // SizedBox(height: 8),
                        // Text(email),
                        // SizedBox(height: 16),
                        // Center(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'OTP',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 18,
                        //         ),
                        //       ),
                        //       SizedBox(width: 8),
                        //       for (var i = 0; i < 6; i++)
                        //         Container(
                        //           width: 40,
                        //           height: 40,
                        //           margin: EdgeInsets.only(right: 1.0),
                        //           decoration: BoxDecoration(
                        //             border: Border.all(),
                        //             borderRadius: BorderRadius.circular(10.0),
                        //           ),
                        //           child: TextField(
                        //             controller: i == 0
                        //                 ? eotpController1
                        //                 : i == 1
                        //                 ? eotpController2
                        //                 : i == 2
                        //                 ? eotpController3
                        //                 : i == 3
                        //                 ? eotpController4
                        //                 : i == 4
                        //                 ? eotpController5
                        //                 : eotpController6,
                        //             maxLength: 1,
                        //             textAlign: TextAlign.center,
                        //             keyboardType: TextInputType.number,
                        //             decoration: const InputDecoration(
                        //               contentPadding: EdgeInsets.symmetric(vertical: 14),
                        //               counterText: '',
                        //             ),
                        //             onChanged: (value) {
                        //               if (value.length == 1 && i < 5) {
                        //                 FocusScope.of(context).nextFocus();
                        //               }
                        //             },
                        //           ),
                        //         ),
                        //       SizedBox(width: 8),
                        //       Container(
                        //         child: TextButton(
                        //           onPressed: () async {
                        //             // Handle OTP verification
                        //             print(eotpController1.text);
                        //             String otp = eotpController1.text +
                        //                 eotpController2.text +
                        //                 eotpController3.text +
                        //                 eotpController4.text +
                        //                 eotpController5.text +
                        //                 eotpController6.text;
                        //             if (otp.length == 6) {
                        //               // Verify the entered OTP
                        //               int d = await AuthService().verifyEmailOTP(emailOTP, otp);
                        //               print(d);
                        //               if(d==1){
                        //                 setState(() {
                        //                   emailVerificationSuccess = true;
                        //                 });
                        //                 Fluttertoast.showToast(
                        //                   msg: 'OTP verified successfully',
                        //                   toastLength: Toast.LENGTH_SHORT,
                        //                   gravity: ToastGravity.BOTTOM,
                        //                   backgroundColor: Colors.grey[800],
                        //                   textColor: Colors.white,
                        //                 );
                        //               }
                        //               else{
                        //                 print("Error");
                        //                 setState(() {
                        //                   emailVerificationSuccess = false;
                        //                 });
                        //               }
                        //             }
                        //           },
                        //           child: emailVerificationSuccess
                        //               ? Container(
                        //             width: 40,
                        //             height: 40,
                        //             decoration: BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               color: Colors.green,
                        //             ),
                        //             child: Icon(Icons.done, color: Colors.white),
                        //           )
                        //               : Text(
                        //             'Verify',
                        //             style: TextStyle(
                        //               color: Colors.red,
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 18,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 16),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(phoneNumber),
                        SizedBox(height: 16),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'OTP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 8),
                              for (var i = 0; i < 6; i++)
                                Container(
                                  width: 40,
                                  height: 40,
                                  margin: EdgeInsets.only(right: 1.0),
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
                              SizedBox(width: 8),
                              Container(
                                child: TextButton(
                                  onPressed: () async {
                                    // Handle OTP verification
                                    String otp = otpController1.text +
                                        otpController2.text +
                                        otpController3.text +
                                        otpController4.text +
                                        otpController5.text +
                                        otpController6.text;
                                    if (otp.length == 6) {
                                      setState(() {
                                        phoneVerificationSuccess = false;
                                      });

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20.0),
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
                                      // Verify the entered OTP
                                      int d = await verifyPhoneOTP(verificationId, otp);
                                      print(d);
                                      Navigator.pop(context); // Close the verification progress dialog
                                      if(d==1){
                                        setState(() {
                                          phoneVerificationSuccess = true;
                                        });
                                        Fluttertoast.showToast(
                                          msg: 'OTP verified successfully',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.grey[800],
                                          textColor: Colors.white,
                                        );
                                      }
                                      else{
                                        Fluttertoast.showToast(
                                          msg: 'Incorrect OTP',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.grey[800],
                                          textColor: Colors.white,
                                        );
                                        print("Error");
                                        setState(() {
                                          phoneVerificationSuccess = false;
                                        });
                                        otpController1.clear();
                                        otpController2.clear();
                                        otpController3.clear();
                                        otpController4.clear();
                                        otpController5.clear();
                                        otpController6.clear();
                                      }
                                    }
                                  },
                                  child: phoneVerificationSuccess
                                      ? Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: const Icon(Icons.done, color: Colors.white),
                                  )
                                      : Stack(
                                    alignment: Alignment.center,
                                    children: const [
                                      IgnorePointer(
                                        ignoring: true,
                                        child: Text(
                                          'Verify',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: IgnorePointer(
                            ignoring: !(phoneVerificationSuccess),
                            child: Opacity(
                              opacity: phoneVerificationSuccess ? 1.0 : 0.5,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.black,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Handle continue button press
                                    if(c==0){
                                      performEmailVerification(context, name, email, phoneNumber, password);
                                    }
                                    else{
                                      SaveUserData(email, dp, name, phoneNumber, age, sex, bg);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  ),
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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
