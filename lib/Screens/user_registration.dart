import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nirogh/services/auth_service.dart';
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
  Color customColor2 = const Color.fromRGBO(247,251,249,255);
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

  bool emailVerificationSuccess = false;
  bool phoneVerificationSuccess = false;
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
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Perform additional logic after successful login
        AuthService.setLoggedIn(true);
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
                      MaterialPageRoute(builder: (context) => HomeScreen()),
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
              title: const Text('Error'),
              content: const Text('Please enter email and password'),
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

  Future<void> signUpWithEmail(BuildContext context) async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String cpassword = cpasswordController.text;

    try {
      if (name.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          cpassword.isNotEmpty) {
        if (password == cpassword) {
          // _showVerifyDialog(email, phone);
          if (email.isNotEmpty) {
              AuthService().performEmailVerification(context, name, email, password);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Warning'),
                  content: const Text(
                      'Please fill in both email'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text('OK'),
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

  @override
  Widget build(BuildContext context) {

    // Get the screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.23,
                child: Image.asset(
                  'lib/Assets/login page-image.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.03,
                  screenHeight * 0.16,
                  screenWidth * 0.03,
                  screenHeight * 0.05,
                ),
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
                                padding:EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenHeight * 0.01),
                                child: Container(
                                  height: screenHeight * 0.05,
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
                                        text: 'Log In',
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
                                    physics: ScrollPhysics(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: SizedBox(
                                    height: screenHeight * 0.6,
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // Login tab content
                                        Column(
                                          children: [
                                            const SizedBox(height: 30),
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: screenWidth*0.05),
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
                                            const SizedBox(height: 15),
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: screenWidth*0.05),
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
                                            SizedBox(height: screenHeight * 0.02),
                                            Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: screenWidth*0.05),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () async {
                                                    // Handle Forget Password click
                                                    await AuthService().showResetPasswordBottomSheet(context);
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
                                              padding: EdgeInsets
                                                  .symmetric(horizontal: screenWidth*0.05),
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
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 25.0),
                                            const Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                  child: Text(
                                                    '------------OR Sign Up With------------',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            FloatingActionButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return WillPopScope(
                                                      onWillPop: () async => false, // Disable popping with back button
                                                      child: const Center(
                                                        child: SpinKitFadingCircle(
                                                          color: Colors.cyan,
                                                          size: 50.0,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                                await AuthService().signInWithGoogle(context);
                                                // AuthService.setLoggedIn(true);
                                                // Navigator.pop(context); // Close the buffering animation dialog
                                                // Navigator.of(context).pushReplacement(
                                                //   MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                                                // );
                                                Navigator.pop(context);
                                              },
                                              elevation: 0,
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              child: Image.asset('lib/Assets/google.png', fit: BoxFit.cover,),
                                            ),
                                            const SizedBox(height: 10.0),
                                            const Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                  child: Text(
                                                    'Google',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Sign Up tab content
                                        Column(
                                          children: [
                                            const SizedBox(height: 0),
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
                                            const SizedBox(height: 0),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              child: TextField(
                                                controller: emailController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Email',
                                                ),
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            const SizedBox(height: 0),
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
                                            const SizedBox(height: 0),
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
                                            const SizedBox(height: 40),
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
                                            const SizedBox(height: 15.0),
                                            const Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                  child: Text(
                                                    '------------OR Sign Up With------------',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                              ),
                                            ),
                                            const SizedBox(height: 15.0),
                                            FloatingActionButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return WillPopScope(
                                                      onWillPop: () async => false, // Disable popping with back button
                                                      child: const Center(
                                                        child: SpinKitFadingCircle(
                                                          color: Colors.cyan,
                                                          size: 50.0,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                                await AuthService().signInWithGoogle(context);
                                                // AuthService.setLoggedIn(true);
                                                // Navigator.pop(context);
                                                // Navigator.of(context).pushReplacement(
                                                //   MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                                                // );
                                                Navigator.pop(context);
                                              },
                                              elevation: 0,
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              child: Image.asset('lib/Assets/google.png', fit: BoxFit.cover,),
                                            ),
                                            const SizedBox(height: 5.0),
                                            const Padding(
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 16.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                  child: Text(
                                                    'Google',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
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
                    SizedBox(height: screenHeight * 0.02),
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
