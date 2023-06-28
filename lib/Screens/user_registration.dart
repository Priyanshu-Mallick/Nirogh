import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({Key? key}) : super(key: key);

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  bool passwordVisibility = true;
  bool cpasswordVisibility = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loginWithEmailAndPassword(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      // Perform login logic here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Successful'),
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
  }

  void signUpWithEmail(BuildContext context) {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String cpassword = cpasswordController.text;

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        password.isNotEmpty &&
        cpassword.isNotEmpty) {
      if (password == cpassword) {
        // Perform signup logic here
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Successful'),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Passwords do not match'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all the fields'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                            color: Colors.cyan.withOpacity(0.5),
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
                                horizontal: 16.0, vertical: 30.0),
                            child: Container(
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
                                  // Set background color for selected tab
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors
                                    .grey, // Set text color for unselected tab
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Flexible( // Wrap TabBarView with Flexible
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Login tab content
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: passwordController,
                                        obscureText: passwordVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              passwordVisibility
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisibility =
                                                !passwordVisibility;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Handle forgot password functionality
                                        },
                                        child: Text('Forgot Password?'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          loginWithEmailAndPassword(context);
                                        },
                                        child: Text('Log In'),
                                      ),
                                    ],
                                  ),
                                ),

                                // Sign Up tab content
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: phoneController,
                                        decoration: InputDecoration(
                                          labelText: 'Phone',
                                        ),
                                      ),
                                      TextFormField(
                                        controller: passwordController,
                                        obscureText: passwordVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              passwordVisibility
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisibility =
                                                !passwordVisibility;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: cpasswordController,
                                        obscureText: cpasswordVisibility,
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              cpasswordVisibility
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                cpasswordVisibility =
                                                !cpasswordVisibility;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          signUpWithEmail(context);
                                        },
                                        child: Text('Sign Up'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      // Handle floating action button press
                    },
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    child: Icon(FontAwesome.google),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}