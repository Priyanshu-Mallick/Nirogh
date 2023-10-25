
import 'dart:io';

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

  final List<CartItem> cartItems = [
    CartItem('Item 1', 25.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 1', 25.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 1', 25.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    CartItem('Item 3', 15.0),
    CartItem('Item 2', 30.0),
    // Add more items as needed
  ];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              selectedDate = newDate;
            });
          },
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
        return CupertinoDatePicker(
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
        title: const Text('Cart Screen'),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cart Items',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    for (var item in cartItems)
                      ListTile(
                        leading: Text(item.itemName),
                        trailing: Text('\$${item.itemPrice.toStringAsFixed(2)}'),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Upload Prescription (optional)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: pickFile,
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
                                      // width: double.infinity,
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
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[300], // Background color
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: fileChosen
                                  ? Text(
                                '$selectedFileName',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                                  : Text('No file chosen'),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text('Upload only jpg, png, or pdf files'),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Patient Name'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Booking Date'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Booking Time'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: Text("${selectedTime.format(context)}"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, right: 16, left: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // Border color
                width: 1.0,         // Border width
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payable amount', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$$totalAmount', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement checkout logic here
                  },
                  child: Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
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
        brwoseFileButtonName = "Browse Again";
        selectedFileName = result.files.single.name;
        fileChosen = true;
      });
    }
  }

}
