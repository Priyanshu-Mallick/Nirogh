
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import '../Widgets/bottom_navigation.dart';
import '../Widgets/file_viewer.dart';

class CartItem {
  final String itemName;
  final double itemPrice;

  CartItem(this.itemName, this.itemPrice);
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedIndex = 2; // Set the default selected index
  double totalAmount = 0.0;
  String selectedFileName = '';
  String selectedFilePath='';
  String brwoseFileButtonName = 'Browse File';
  bool fileChosen = false; // Declare fileChosen as an instance variabl
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController =  TextEditingController();

  final List<CartItem> cartItems = [
    CartItem('Item 1', 25.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    // Add more items as needed
  ];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the sigma values for the blur effect
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
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the sigma values for the blur effect
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

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[300],
        title: const Text('Cart Items'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 250, // Set a height for the container
                child: Scrollbar(
                  thumbVisibility: true, // Show the scrollbar always
                  child: ListView(
                    physics: BouncingScrollPhysics(), // Use BouncingScrollPhysics
                    children: cartItems.map((item) {
                      return ListTile(
                        leading: Text(item.itemName),
                        trailing: Text('\$${item.itemPrice.toStringAsFixed(2)}'),
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
                    padding: const EdgeInsets.only(left: 15),
                    child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text('\$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              Divider(thickness: 1.5),
              SizedBox(height: 10),
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
                        borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
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
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey[300],
                      ),
                      width: 250, // Set a constant width
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
              SizedBox(height: 20),
              TextField(
                readOnly: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.25),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  labelText: "Full Name",
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  prefixIconColor: Colors.black,
                ),
                controller: _fullNameController,
              ),
              SizedBox(height: 8),
              TextField(
                readOnly: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.25),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  labelText: "Address",
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.add_location),
                  prefixIconColor: Colors.black,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () {
                      // Add your location fetch logic here
                    },
                    color: Colors.black,
                  ),
                ),
                controller: _addressController,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text('Booking Date'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.4, // Set the desired width for the button
                    child: ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
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
                    width: MediaQuery.of(context).size.width*0.4, // Set the desired width for the button
                    child: ElevatedButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
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
                        Text('Payable amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('\$$totalAmount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.4, // Set the desired width for the button
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement checkout logic here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Set the button background color to black
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
                          ),
                        ),
                        child: Text('Checkout', style: TextStyle(fontSize: 15, color: Colors.white),),
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
      String uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}";

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

}
