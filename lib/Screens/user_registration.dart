import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirogh/services/auth_service.dart';
import 'package:nirogh/firebase_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nirogh/Screens/home_screen.dart';
import 'package:nirogh/Screens/profile_setup.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({Key? key}) : super(key: key);

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  bool passwordVisibility = true;
  bool cpasswordVisibility = true;
  Color customColor1 = const Color.fromRGBO(176,248,224,255);
  Color customColor2 = Color.fromRGBO(247,251,249,255);
  bool isOTPSent = false; // Add this variable to track whether OTP has been sent
  FirebaseAuth auth = FirebaseAuth.instance; // Declare the auth variable outside the sendOTP method


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
  int otp=0;

  bool isEmailVerified = false;
  bool isPhoneVerified = false;

  // For firebase state management
  @override
  void initState() {
    super.initState();
    initializeFirebase();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Initialize the firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    // _firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loginWithEmailAndPassword(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Perform additional logic after successful login

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Successful'),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please enter email and password'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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

  Future<void> signUpWithEmail(BuildContext context) async {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String cpassword = cpasswordController.text;

    try {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          phone.isNotEmpty &&
          password.isNotEmpty &&
          cpassword.isNotEmpty) {
        if (password == cpassword) {
          // _showVerifyDialog(email, phone);
          if (email.isNotEmpty && phone.isNotEmpty) {
            // Phone number validation
            if (phone.length == 10 && int.tryParse(phone) != null) {
              otp=await AuthService().sendOTP(phone,email);
              _showVerifyDialog(email, phone, otp);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Warning'),
                    content: const Text('Invalid phone number. Please enter a 10-digit phone number.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Warning'),
                  content: const Text(
                      'Please fill in both email and phone number fields.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Passwords do not match'),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Please fill all the fields'),
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

  void _showVerifyDialog(String email, String phoneNumber, int OTP) {
    double sheetHeight = MediaQuery.of(context).size.height * 0.72;
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
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Email ID',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(email),
                        SizedBox(height: 16),
                        Row(
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
                            SizedBox(width: 16),
                            Container(
                              child: TextButton(
                                onPressed: () {
                                  // Handle OTP verification
                                  print(eotpController1.text);
                                  String otp = eotpController1.text +
                                      eotpController2.text +
                                      eotpController3.text +
                                      eotpController4.text +
                                      eotpController5.text +
                                      eotpController6.text;
                                  if (otp.length == 6) {
                                    // Perform OTP verification
                                    // bool isOTPVerified =
                                    // AuthService().verifyOTP(otp) as bool; // Assuming AuthService().verifyOTP() returns a boolean indicating the verification status
                                    int d = AuthService().verifyOTP(otp,OTP);
                                    if(d==1){
                                      Fluttertoast.showToast(
                                        msg: 'OTP verified successfully',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.grey[800],
                                        textColor: Colors.white,
                                      );
                                    }
                                    else{
                                      print("Error");
                                    }

                                    // setState(() {
                                    //   isEmailVerified = isOTPVerified;
                                    // });
                                  }
                                },
                                    child: const Text(
                                      'Verify',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
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
                        Row(
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
                            SizedBox(width: 16),
                            Container(
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
                                    // bool verified = (await AuthService().verifyOTP(otp)) as bool; // Assuming AuthService().verifyOTP() returns a boolean indicating the verification status
                                    // if (verified) {
                                    //   // Perform necessary actions upon successful OTP verification
                                    // } else {
                                    //   // Handle OTP verification failure
                                    // }

                                  }
                                },
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets
                              .symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  30.0),
                              color: Colors.black,
                            ),
                            child: TextButton(
                              onPressed: () {
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty
                                    .all<Color>(
                                  Colors.white,
                                ),
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


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                child: Image.asset(
                  'lib/Assets/login page-image.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 130.0, 20.0, 30.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: customColor1.withOpacity(1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 30.0),
                                child: Container(
                                  height: 40.0,
                                  // Set the desired height for the TabBar
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: TabBar(
                                    controller: _tabController,
                                    tabs: const [
                                      Tab(
                                        text: 'Login',
                                      ),
                                      Tab(
                                        text: 'Sign Up',
                                      ),
                                    ],
                                    indicator: BoxDecoration(
                                      color: Colors.cyanAccent,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.6,
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // Login tab content
                                        Column(
                                          children: [
                                            SizedBox(height: 30),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: TextField(
                                                controller: emailController,
                                                decoration: const InputDecoration(
                                                  labelText:
                                                  'Enter email or username',
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: TextField(
                                                controller: passwordController,
                                                obscureText:
                                                passwordVisibility,
                                                decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      passwordVisibility
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        passwordVisibility =
                                                        !passwordVisibility;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20.0),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Handle Forget Password click
                                                  },
                                                  child: Text(
                                                    'Forget Password?',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 50.0),
                                            // ...
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets
                                                  .symmetric(horizontal: 16.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      30.0),
                                                  color: Colors.black,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    loginWithEmailAndPassword(
                                                        context);
                                                  },
                                                  style: ButtonStyle(
                                                    foregroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Log In',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 25.0),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Handle Forget Password click
                                                  },
                                                  child: const Text(
                                                    'OR',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20.0),
                                            Container(
                                              child: FloatingActionButton(
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return WillPopScope(
                                                        onWillPop: () async => false, // Disable popping with back button
                                                        child: Center(
                                                          child: SpinKitFadingCircle(
                                                            color: Theme.of(context).primaryColor,
                                                            size: 50.0,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  final user = await AuthService().signInWithGoogle();
                                                  Navigator.pop(context); // Close the buffering animation dialog
                                                  if (user != null) {
                                                    final displayName = await AuthService().getUserDisplayName();
                                                    final userName = await AuthService().getUniqueUsername(displayName!);
                                                    await AuthService().storeUserDisplayName(displayName!, userName);
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ProfileSetup()),
                                                    );
                                                  }
                                                },
                                                elevation: 0,
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                child: Image.asset('lib/Assets/google.png', fit: BoxFit.cover,),
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Handle Forget Password click
                                                  },
                                                  child: const Text(
                                                    'Sign Up With',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Sign Up tab content
                                        Column(
                                          children: [
                                            SizedBox(height: 0),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: TextField(
                                                controller: nameController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Name',
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 0),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              child: TextField(
                                                controller: emailController,
                                                decoration: InputDecoration(
                                                  labelText: 'Email',
                                                ),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            SizedBox(height: 0),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              child: TextField(
                                                controller: phoneController,
                                                decoration: InputDecoration(
                                                  labelText: 'Phone Number',
                                                ),
                                                style: TextStyle(fontSize: 15),
                                                keyboardType: TextInputType.number,
                                              ),
                                            ),
                                            SizedBox(height: 0),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: TextField(
                                                controller: passwordController,
                                                obscureText:
                                                passwordVisibility,
                                                decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      passwordVisibility
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        passwordVisibility =
                                                        !passwordVisibility;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 0),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: TextField(
                                                controller:
                                                cpasswordController,
                                                obscureText:
                                                cpasswordVisibility,
                                                decoration: InputDecoration(
                                                  labelText: 'Confirm Password',
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      cpasswordVisibility
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        cpasswordVisibility =
                                                        !cpasswordVisibility;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 40),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets
                                                  .symmetric(horizontal: 16.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      30.0),
                                                  color: Colors.black,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    signUpWithEmail(context);
                                                  },
                                                  style: ButtonStyle(
                                                    foregroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Sign Up',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15.0),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Handle Forget Password click
                                                  },
                                                  child: const Text(
                                                    'OR',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15.0),
                                            Container(
                                              child: FloatingActionButton(
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return WillPopScope(
                                                        onWillPop: () async => false, // Disable popping with back button
                                                        child: Center(
                                                          child: SpinKitFadingCircle(
                                                            color: Theme.of(context).primaryColor,
                                                            size: 50.0,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  final user = await AuthService().signInWithGoogle();
                                                  Navigator.pop(context); // Close the buffering animation dialog
                                                  if (user != null) {
                                                    final displayName = await AuthService().getUserDisplayName();
                                                    final userName = await AuthService().getUniqueUsername(displayName!);
                                                    await AuthService().storeUserDisplayName(displayName!, userName);
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ProfileSetup()),
                                                    );
                                                  }
                                                },
                                                elevation: 0,
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                child: Image.asset('lib/Assets/google.png', fit: BoxFit.cover,),
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Handle Forget Password click
                                                  },
                                                  child: const Text(
                                                    'Sign Up With',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Terms & Conditions | Privacy Policy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
