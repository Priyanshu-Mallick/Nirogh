import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../services/manage_cart.dart';
import '../services/shared_preference_services.dart';

class PopularTestsWidget extends StatefulWidget {

  final Function(String, double) onBookNowClick;

  PopularTestsWidget({required this.onBookNowClick});

  @override
  _PopularTestsWidgetState createState() => _PopularTestsWidgetState();
}

class _PopularTestsWidgetState extends State<PopularTestsWidget> {
  Map<String, dynamic> testsData = {}; // Map to store test data fetched from the backend
  // List<CartItem> cartItems = [];
  // Assuming you have a reference to CartScreen

  @override
  void initState() {
    super.initState();
    // Fetch test data when the widget initializes
    loadTestDataFromCache();
    fetchTestData();
  }

  Future<void> loadTestDataFromCache() async {
    final cachedData = await SharedPreferencesService.retrieveTestDataFromCache();
    setState(() {
      testsData = cachedData;
    });
  }

  Future<void> fetchTestData() async {
    // Replace this URL with your backend API endpoint to fetch test data
    final apiUrl = 'https://nirogh.com/bapi/mrp/list?id=1';

    try {
      // Make a GET request to fetch test data from the backend
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          // Update the testsData map with fetched data
          testsData = data['data'];
        });
        SharedPreferencesService.saveTestDataToCache(testsData);
      } else {
        // Handle error if the request fails
        print('Failed to fetch test data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exceptions that occur during the process
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Your existing UI code for 'Popular Tests' text and Explore button...

        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Tests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle Explore button click action
                  // Navigate to the Explore page or perform an action
                },
                child: const Text(
                  'Explore >',
                  style: TextStyle(
                    color: Colors.grey, // Change color as needed
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(10, 8),
              ),
            ],
          ),
          child: SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: testsData.length,
              itemBuilder: (context, index) {
                final testName = testsData.keys.toList()[index];
                final testPrice = testsData.values.toList()[index];

                return GestureDetector(
                  onTap: () {
                    _handleTestClick(context, testName); // Handle the click event here
                  },
                  child: Container(
                    width: 130,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          testName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\u20B9 $testPrice',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            _handleBookNowClick(testName, testPrice); // Handle book now button click here
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleTestClick(BuildContext context, String testName) {
    print('Test $testName clicked');
    // Handle the test click event here
    // You can navigate to another page or perform any action you want
  }

  void _handleBookNowClick(String testName, double testPrice) {
    print('Book Now clicked for Test $testName');
    Provider.of<CartModel>(context, listen: false).addCartItem(testName, testPrice);
  }

}
