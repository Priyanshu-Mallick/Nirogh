import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/shared_preference_services.dart'; // Add the appropriate HTTP package for fetching data

class PopularLabsWidget extends StatefulWidget {
  @override
  _PopularLabsWidgetState createState() => _PopularLabsWidgetState();
}

class _PopularLabsWidgetState extends State<PopularLabsWidget> {
  List<Map<String, dynamic>> labs = []; // List to store lab data fetched from the backend

  @override
  void initState() {
    super.initState();
    // Fetch lab data when the widget initializes
    fetchLabData();
    retrieveCachedLabs();
  }

  Future<void> fetchLabData() async {
    final apiUrl = 'https://nirogh.com/bapi/diagnostics/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if 'data' is a List
        if (data['data'] is List) {
          setState(() {
            // Update the labs list with fetched data as an array of strings
            labs = (data['data'] as List).map((labName) {
              return {
                'name': labName,
                'logoUrl': '', // Replace with actual logic to get the logo URL if available
              };
            }).toList();
          });
        }
        await SharedPreferencesService.saveLabsToCache(labs);
      } else {
        // Handle error if the request fails
        print('Failed to fetch data: ${response.statusCode}');
        print('Failed to fetch data: ${response.body}');
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
        // Your existing UI code for 'Popular Labs' text and Explore button...

        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Labs',
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
                child: Text(
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
              itemCount: labs.length, // Use the fetched labs data count
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _handleLabClick(context, index); // Handle the click event here
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
                        Image.network(
                          labs[index]['logoUrl'], // Use the fetched logo URL
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          labs[index]['name'], // Use the fetched lab name
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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

  Future<void> retrieveCachedLabs() async {
    final cachedLabs = await SharedPreferencesService.retrieveLabsFromCache();
    if (cachedLabs.isNotEmpty) {
      setState(() {
        labs = cachedLabs;
      });
    } else {
      fetchLabData(); // Fetch the labs data if it's not available in cache
    }
  }
  void _handleLabClick(BuildContext context, int index) {
    print('Lab ${labs[index]['name']} clicked');
    // Handle the click event here
    // You can navigate to another page or perform any action you want
  }
}
