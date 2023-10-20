import 'package:flutter/material.dart';

class PopularLabsWidget extends StatefulWidget {
  @override
  _PopularLabsWidgetState createState() => _PopularLabsWidgetState();
}

class _PopularLabsWidgetState extends State<PopularLabsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Popular Labs',
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
                offset: const Offset(10, 8),
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
                    _handleLabClick(context, index); // Handle the click event here
                  },
                  child: Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/Assets/lab${index + 1}.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          getLabName(index),
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

  String getLabName(int index) {
    switch (index) {
      case 0:
        return 'Dr Lal Patho Lab';
      case 1:
        return 'BP Laboratory';
      case 2:
        return 'Cure Well Labs';
      case 3:
        return 'Agilus Diagnostics';
      default:
        return '';
    }
  }

  void _handleLabClick(BuildContext context, int index) {
    // Handle the click event here
    print('Lab ${index + 1} clicked');
    // You can navigate to another page or perform any action you want
  }
}
