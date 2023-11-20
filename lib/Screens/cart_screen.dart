
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../Widgets/bottom_navigation.dart';
import '../Widgets/file_viewer.dart';
import '../services/cart_item_class.dart';
import '../services/manage_cart.dart';

class CartScreen extends StatefulWidget {

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedIndex = 2; // Set the default selected index
  double totalAmount = 0.0;
  String selectedFileName = '';
  String selectedFilePath = '';
  String brwoseFileButtonName = 'Browse File';
  bool fileChosen = false; // Declare fileChosen as an instance variabl
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isFetchingLocation = true;
  double? lat;
  double? long;
  String? address;


  // final List<CartItem> cartItems = [
  //   CartItem('Item 1', 25.0),
  //   CartItem('Item 2', 30.0),
  //   CartItem('Item 3', 15.0),
  //   CartItem('Item 2', 30.0),
  //   CartItem('Item 3', 15.0),
  //   CartItem('Item 2', 30.0),
  //   CartItem('Item 3', 15.0),
  //   CartItem('Item 2', 30.0),
  //   CartItem('Item 3', 15.0),
  //   CartItem('Item 2', 30.0),
  //   CartItem('Item 3', 15.0),
  //   CartItem('Item 2', 30.0),
  //   CartItem('Item 3', 15.0),
  //   // Add more items as needed
  // ];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              // Adjust the sigma values for the blur effect
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Center(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
              ),
            ),
          ],
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              // Adjust the sigma values for the blur effect
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Center(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                ),
                onDateTimeChanged: (DateTime newTime) {
                  setState(() {
                    selectedTime = TimeOfDay.fromDateTime(newTime);
                  });
                },
              ),
            ),
          ],
        );
      },
    );

    if (picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Function to handle file selection
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path! as String);

      // Get the app's cache directory
      Directory appCacheDir = await getTemporaryDirectory();

      // Generate a unique file name in the cache directory
      String uniqueFileName = "${DateTime
          .now()
          .millisecondsSinceEpoch}_${result.files.single.name}";

      // Create a new file in the cache directory
      File newFile = File("${appCacheDir.path}/$uniqueFileName");

      // Copy the selected file to the cache directory
      await newFile.writeAsBytes(await file.readAsBytes());

      setState(() {
        selectedFilePath = newFile.path;
        brwoseFileButtonName = "Change File";
        selectedFileName = result.files.single.name;
        fileChosen = true;
      });
    }
  }

  Future<void> getLatLong() async {
    setState(() {
      isFetchingLocation = true;
    });

    Position position;
    try {
      position = await _determinePosition();
      lat = position.latitude;
      long = position.longitude;
      await updateText();
    } catch (error) {
      print("Error $error");
    } finally {
      setState(() {
        isFetchingLocation = false;
      });
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> updateText() async {
    if (lat != null && long != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat!, long!);
      address =
      '${placemarks[0].street} ${placemarks[0].subLocality}, ${placemarks[0]
          .locality}, ${placemarks[0].administrativeArea}, PIN: ${placemarks[0]
          .postalCode}';
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;
    final cartItems = Provider.of<CartModel>(context).cartItems;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[300],
          title: const Text('Cart Items'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart,
                size: screenSize.width * 0.2,
                color: Colors.grey,
              ),
              SizedBox(height: screenSize.width * 0.04),
              Text(
                'No items found in cart',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.05,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          initialIndex: _selectedIndex,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[300],
        title: const Text('Cart Items'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.03),
          child: Column(
            children: [
              Container(
                height: screenSize.height * 0.3,
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: cartItems.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final CartItem item = entry.value;

                      return Dismissible(
                        key: Key(item.itemName), // Unique key for each item
                        onDismissed: (direction) {
                          // Remove the item from the list when dismissed
                          setState(() {
                            cartItems.removeAt(index);
                          });
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          leading: Text(item.itemName),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$${item.itemPrice.toStringAsFixed(2)}'),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Handle the delete action on tapping the delete icon
                                  setState(() {
                                    cartItems.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Divider(thickness: 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.04),
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.width * 0.04,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenSize.width * 0.04),
                    child: Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.width * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1.5),
              SizedBox(height: screenSize.width * 0.02),
              Text(
                'Upload Prescription (optional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: pickFile,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            screenSize.width * 0.1),
                      ),
                    ),
                    child: Text('$brwoseFileButtonName'),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (fileChosen) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Preview File'),
                              content: Container(
                                child: getFilePreviewWidget(selectedFilePath),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(screenSize.width * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            screenSize.width * 0.1),
                        color: Colors.grey[300],
                      ),
                      width: screenSize.width * 0.62,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            fileChosen
                                ? Text(
                              '$selectedFileName',
                            )
                                : Text('No file chosen'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text('Upload only jpg, png, or pdf files'),
              SizedBox(height: screenSize.width * 0.04),
              TextField(
                readOnly: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenSize.width * 0.025),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.25),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  labelText: "Full Name",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: screenSize.width * 0.035,
                  ),
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  prefixIconColor: Colors.black,
                ),
                controller: _fullNameController,
              ),
              SizedBox(height: screenSize.width * 0.02),
              TextField(
                readOnly: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: screenSize.width * 0.025),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.25),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  labelText: "Address",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: screenSize.width * 0.035,
                  ),
                  prefixIcon: const Icon(Icons.add_location),
                  prefixIconColor: Colors.black,
                  suffixIcon: FutureBuilder(
                    future: isFetchingLocation ? getLatLong() : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Icon(Icons.my_location);
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error);
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: () {
                            if (address != null) {
                              _addressController.text = address!;
                            }
                          },
                          color: Colors.black,
                        );
                      }
                    },
                  ),
                ),
                controller: _addressController,
              ),
              SizedBox(height: screenSize.width * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Text('Booking Date'),
                  ),
                  Container(
                    width: screenSize.width * 0.45,
                    child: ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenSize.width *
                              0.1),
                        ),
                      ),
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Booking Time'),
                  ),
                  Container(
                    width: screenSize.width * 0.45,
                    child: ElevatedButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenSize.width *
                              0.1),
                        ),
                      ),
                      child: Text("${selectedTime.format(context)}"),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1.5),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payable amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.width * 0.035,
                            )),
                        Text('\$$totalAmount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.width * 0.035,
                            )),
                      ],
                    ),
                    Container(
                      width: screenSize.width * 0.45,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement checkout logic here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                screenSize.width * 0.1),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(fontSize: screenSize.width * 0.035,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        initialIndex: _selectedIndex,
      ),
    );
  }
}
