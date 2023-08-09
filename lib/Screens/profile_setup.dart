import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nirogh/Screens/home_screen.dart';
import '../widgets/profile_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}


class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String userProfilePic = '';
  String userName = '';
  String phoneNumber = '';
  String selectedAge = '';
  String selectedSex = '';
  String selectedBlood = '';
  late bool isDarkMode;
  late List<String> choices = [];
  late TextEditingController _phoneNumberController;

  File? _image;

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        setState(() {
          // Assign the retrieved data to the corresponding variables
          // Update the variables you use here based on the actual field names in Firestore
          userProfilePic = userData?['profilePictureUrl'] ?? '';
          userName = userData?['fullName'] ?? '';
          // Add other fields if needed
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _phoneNumberController = TextEditingController();
  }

  Future _getImage(ImageSource source) async {
    try{
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
      });
    } on PlatformException catch (e){
      print(e);
      Navigator.of(context).pop();
    }
  }


  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if(croppedImage == null) return null;
    return File(croppedImage.path);
  }


  void openImageBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.transparent, // Set the background color to transparent
      builder: (BuildContext context) {
        return Stack(
          children: [
            // The blurred content of the background page
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the sigma values for the blur effect
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // The bottom sheet content
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Image Source',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Send the image
                      _getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.camera,
                      size: 24,
                    ),
                    label: const Text('Camera'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Send the image
                      _getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.photo),
                    label: const Text('Gallery'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChoiceBottomSheet(BuildContext context, int c, String ctext) async {
    dynamic result;
    if(c == 1) {
      result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
                    color: isDarkMode? Colors.grey.withOpacity(0.5) : Colors.cyanAccent.withOpacity(0.5),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: isDarkMode ? Colors.grey : Colors.cyanAccent,
                        width: 4)
                ),
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CupertinoPicker(

                    scrollController: FixedExtentScrollController(
                      initialItem: 3,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedAge = choices[index];
                      });
                    },
                    children: choices.map((choice) {
                      return Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width:2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 20),
                          child: Center(
                            child: Text(
                              choice,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: Text(ctext, style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white
                      )),
                    ),
                  )
              )
            ],
          );
        },
      );
    }
    else if(c == 2)
    {
      result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
                    color: isDarkMode ? Colors.grey.withOpacity(0.5) : Colors.cyanAccent.withOpacity(0.5),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: isDarkMode ? Colors.grey : Colors.cyanAccent,
                        width: 4)
                ),
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CupertinoPicker(

                    scrollController: FixedExtentScrollController(
                      initialItem: 3,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedSex = choices[index];
                      });
                    },
                    children: choices.map((choice) {
                      return Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width:2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 20),
                          child: Center(
                            child: Text(
                              choice,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: Text(ctext, style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white
                      )),
                    ),
                  )
              )
            ],
          );
        },
      );
    }
    else
    {
      result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
                    color: isDarkMode ? Colors.grey.withOpacity(0.5) : Colors.cyanAccent.withOpacity(0.5),
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: isDarkMode ? Colors.grey : Colors.cyanAccent,
                        width: 4)
                ),
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CupertinoPicker(

                    scrollController: FixedExtentScrollController(
                      initialItem: 3,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedBlood = choices[index];
                      });
                    },
                    children: choices.map((choice) {
                      return Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width:2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 20),
                          child: Center(
                            child: Text(
                              choice,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                      child: Text(ctext, style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white
                      )),
                    ),
                  )
              )
            ],
          );
        },
      );
    }
    if (result != null) {
      if(c == 1) {
        setState(() {
          selectedAge = result;
        });
      }
      else if(c == 2) {
        setState(() {
          selectedSex = result;
        });
      }
      else if(c == 3) {
        setState(() {
          selectedBlood = result;
        });
      }
    }
  }

  void SaveUserData(String userProfilePic, String userName, String phoneNumber, String selectedAge, String selectedSex, String selectedBlood){
    print(userProfilePic);
    print(userName);
    print(phoneNumber);
    print(selectedAge);
    print(selectedSex);
    print(selectedBlood);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
        return MaterialApp(
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    backgroundColor: isDarkMode ? Colors.black : Colors.white,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    title: Text(
                      "Profile",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                      gradient: !isDarkMode
                          ? LinearGradient(
                        colors: [
                          Colors.cyanAccent.withOpacity(0.5),
                          Colors.white70,
                          Colors.white70,
                          Colors.white70,
                          Colors.cyanAccent.withOpacity(0.5)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : const LinearGradient(
                        colors: [
                          Colors.white70,
                          Colors.black26,
                          Colors.black38,
                          Colors.black26,
                          Colors.white70,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _image != null
                                    ? Image.file(_image!)
                                    : userProfilePic.isNotEmpty
                                    ? Image.network(
                                  userProfilePic,
                                  fit: BoxFit.cover,
                                )
                                    : Transform.scale(
                                  scale: 7.0, // Adjust this value to increase or decrease the icon size
                                  child: const Icon(CupertinoIcons.person_crop_circle_fill),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 19,
                                child: IconButton(
                                  onPressed: () => openImageBottomSheet(),
                                  color: Colors.black,
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            ProfileTextField(
                              ttext: userName != ''
                              ? userName : "Full Name",
                              ctext: userName,
                              icon: const Icon(Icons.person_2_outlined),
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileTextField(
                              ttext: "Phone number",
                              icon: const Icon(Icons.phone),
                              isDarkMode: isDarkMode,
                              ctext: _phoneNumberController.text,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileTextField(
                              read: true,
                              ctext: selectedAge,
                              ttext: 'Age',
                              icon: const Icon(Icons.calendar_today_outlined),
                              isDarkMode: isDarkMode,
                              onTap: () {
                                choices.clear();
                                for (int i = 1; i <= 120; i++) {
                                  choices.add(i.toString());
                                }
                                _showChoiceBottomSheet(context,1, "Select Age");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileTextField(
                              read: true,
                              ctext: selectedSex,
                              ttext: 'Sex',
                              icon: const Icon(Icons.transgender_outlined),
                              isDarkMode: isDarkMode,
                              onTap: () {
                                selectedSex = '';
                                choices.clear();
                                choices = ["Male", "Female", "Transgender", "Others"];
                                _showChoiceBottomSheet(context,2,"Select Sex");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileTextField(
                              read: true,
                              ctext: selectedBlood,
                              ttext: 'Blood Group',
                              icon: const Icon(Icons.water_drop),
                              isDarkMode: isDarkMode,
                              onTap: () {
                                selectedBlood = '';
                                choices.clear();
                                choices = ["A+", "B+", "AB+","O+", "A-","B-","AB-","O-"];
                                _showChoiceBottomSheet(context,3,"Select Blood Group");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () {
                                  SaveUserData(userProfilePic, userName, _phoneNumberController as String, selectedAge, selectedSex, selectedBlood);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  isDarkMode ? Colors.yellowAccent : Colors.greenAccent,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  "Save Profile",
                                  style: TextStyle(color: Colors.black, fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Nirogh", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isDarkMode? Colors.white : Colors.black,
                                )),
                                Text("The result you can Trust!", style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                  color: isDarkMode? Colors.white : Colors.black,
                                )),

                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}