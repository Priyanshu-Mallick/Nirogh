import 'package:flutter/material.dart';
import 'package:nirogh/Screens/search_lab.dart';

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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Labs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Explore >',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    // Icon(Icons.chevron_right, color: Colors.grey, size: 17,),
                  ],
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
              itemCount: 4,
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
