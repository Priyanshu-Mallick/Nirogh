import 'package:flutter/material.dart';

class PopularTestsWidget extends StatefulWidget {
  @override
  _PopularTestsWidgetState createState() => _PopularTestsWidgetState();
}

class _PopularTestsWidgetState extends State<PopularTestsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Popular Tests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
                offset: Offset(10, 8),
              ),
            ],
          ),
          child: SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _handleTestClick(context, index); // Handle the click event here
                  },
                  child: Container(
                    width: 130,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTestName(index),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          getPriceTag(index),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            _handleBookNowClick(context, index); // Handle book now button click here
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.cyan,
                          ),
                          child: Text('Book Now'),
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

  String getTestName(int index) {
    switch (index) {
      case 0:
        return 'Lapid Profile';
      case 1:
        return 'Kidney Functional Test';
      case 2:
        return 'Covid Test';
      case 3:
        return 'City Scan';
      default:
        return '';
    }
  }

  String getPriceTag(int index) {
    switch (index) {
      case 0:
        return '\u20B9 1000'; // Rupees symbol
      case 1:
        return '\u20B9 1500'; // Rupees symbol
      case 2:
        return '\u20B9 500'; // Rupees symbol
      case 3:
        return '\u20B9 5000'; // Rupees symbol
      default:
        return '';
    }
  }

  void _handleTestClick(BuildContext context, int index) {
    // Handle the test click event here
    print('Test ${index + 1} clicked');
    // You can navigate to another page or perform any action you want
  }

  void _handleBookNowClick(BuildContext context, int index) {
    // Handle the book now button click event here
    print('Book Now clicked for Test ${index + 1}');
    // You can navigate to another page or perform any action you want
  }
}
