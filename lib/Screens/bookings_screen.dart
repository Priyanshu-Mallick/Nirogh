import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/bottom_navigation.dart';
import 'package:nirogh/services/track_order.dart';

import 'home_screen.dart';

class Booking {
  final String bookingId;
  final String testName;
  final String scheduledDate;
  final String scheduledTime;
  final double price;
  final String name;
  final String sex;
  final int age;
  late final int complete; //1-complete, 2-pending, 3-cancelled
  final String address;

  Booking({
    required this.bookingId,
    required this.testName,
    required this.scheduledDate,
    required this.price,
    required this.scheduledTime,
    this.complete = 2,
    this.name = "Priyanshu Mallick",
    this.sex = "Transgender",
    this.age = 21,
    this.address = "Nrushingha, Atharnala, Puri, Odisha, India, P.I.N. - 752002",
  });

}

List<Booking> bookings = [
  Booking(bookingId: '1', testName: 'HIV test', scheduledDate: '2023-07-31', price: 1000000.0, scheduledTime: '10:30 am - 1:00 pm', complete: 1),
  Booking(bookingId: '2', testName: 'Piles Drilling Test', scheduledDate: '2023-08-01', price: 1000.0, scheduledTime: '', complete: 3),
  Booking(bookingId: '3', testName: 'Ear,, Nose, Throat', scheduledDate: '2023-08-02', price: 1000.0, scheduledTime: ''),
  Booking(bookingId: '4', testName: 'Ear,, Nose, Throat', scheduledDate: '2023-08-02', price: 1000.0, scheduledTime: ''),
  Booking(bookingId: '5', testName: 'Ear,, Nose, Throat', scheduledDate: '2023-08-02', price: 1000.0, scheduledTime: ''),
];


class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final int _selectedIndex = 1; // Set the default selected index
  Color darkCyan = const Color.fromRGBO(0, 110, 160, 1.0);
  Color darkRed = const Color.fromRGBO(100, 0, 0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: bookings.isNotEmpty
            ? Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              icon: const Icon(CupertinoIcons.square_grid_2x2, color: Colors.black),
            ),
            title: const Text('My Bookings', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.cyan[300],
          ),
          body: Container(
            color: Colors.black12,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                Booking booking = bookings[index];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Ref Id. #${booking.bookingId} ",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            booking.complete == 1
                                ? Row(
                              children: const [
                                Icon(Icons.check_circle_rounded, color: Colors.green),
                                Text(
                                  "Completed!",
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            )
                                : booking.complete == 2
                                ? Row(
                              children: const [
                                Icon(Icons.flag_circle_rounded, color: Colors.orange),
                                Text(
                                  "Pending!",
                                  style: TextStyle(
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            )
                                : Row(
                              children: const [
                                Icon(Icons.cancel, color: Colors.red),
                                Text(
                                  "Cancelled!",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        buildPopupMenuButton(context, index, booking.complete, booking.bookingId)
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.add_box_rounded),
                            SizedBox(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(booking.testName,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text("${booking.scheduledDate} at ${booking.scheduledTime}", style: const TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.person_2_outlined),
                            SizedBox(
                              width: 270,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: SizedBox(
                                      width: 120,
                                      child: Text(booking.name,
                                        overflow: TextOverflow.clip,),
                                    ),
                                  ),
                                  Text("${booking.sex}, ${booking.age} Yrs",),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_pin),
                            SizedBox(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(booking.address,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
            : Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: const Text('Bookings', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyanAccent.withOpacity(0.5),
                  Colors.white70,
                  Colors.white70,
                  Colors.white70,
                  Colors.cyanAccent.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/image1.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 15),
                const Text(
                  "No Bookings Yet!!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to execute on button press
        },
        elevation: 10,
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.call),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBarWidget(initialIndex: _selectedIndex),
    );
  }
  // void _showSnackbar(BuildContext context, String message) {
  //   final snackbar = SnackBar(
  //     content: Text(message),
  //     backgroundColor: Colors.red,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // }

  PopupMenuButton<String> buildPopupMenuButton(BuildContext context, int index, int complete, String bookingId) {
    if (complete == 2) {
      return PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: darkCyan),
        onSelected: (String result) {
          if (result == 'track') {
            // _showSnackbar(context, 'This functionality will be updated soon');
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => TrackingScreen(id: bookingId)),
            // );
          } else if (result == 'cancel') {
            _showCancelBottomSheet(context, index);
          } else if (result == 'download') {
            // Add your logic for the "Download" option
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'download',
            child: Text('Download'),
          ),
          const PopupMenuItem<String>(
            value: 'track',
            child: Text('Track'),
          ),
          const PopupMenuItem<String>(
            value: 'cancel',
            child: Text('Cancel'),
          ),
        ],
      );
    } else {
      return PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: darkCyan),
        onSelected: (String result) {
          if (result == 'download') {
            // Add your logic for the "Download" option
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'download',
            child: Text('Download'),
          ),
        ],
      );
    }
  }

  void _showCancelBottomSheet(BuildContext context, int index){
    showModalBottomSheet<void>(
        backgroundColor: Colors.white.withOpacity(0),
        context: context,
        builder: (BuildContext context){
          return Column(
            children: [
              Container(
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Text('${bookings[index].complete}', style: TextStyle(fontSize: 40, color: Colors.red)),
                    const Text('Confirm your Cancellation'),
                    const Divider(thickness: 2,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent.withOpacity(0.7)
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text('Confirm Cancel', style: TextStyle(color: Colors.black),)
                    )
                  ],
                ),
              ),
              const SizedBox(height: 150,)
            ],
          );
        }
    );
  }
}
