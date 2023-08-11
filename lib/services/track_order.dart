import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Color darkCyan = const Color.fromRGBO(0, 100, 225 ,1.0);

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final Completer<GoogleMapController> mapController = Completer();
  double _rating = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.view_agenda_outlined, color: Colors.black),
          ),
          title: Text('Booking Id: ${widget.id}', style: const TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(48.8584, 2.2945),
                zoom: 15,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId("source"),
                  position: LatLng(48.8584, 2.2945),
                )
              },
              zoomControlsEnabled: false,
            ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                height: 180,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    color: darkCyan.withOpacity(0.9),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, -4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: Colors.white,
                            leading: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 25,
                              backgroundImage: AssetImage('your_image_path_here'), // Add an image if desired
                            ),
                            title: const Text(
                              "Swastik - The Khalnayak",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: RatingBar.builder(
                              initialRating: _rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 30,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating = rating;
                                });
                              },
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.message,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(thickness: 2,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(onPressed: (){},
                                  child: const Text("Pay Now", style: TextStyle(fontSize: 20),)
                              ),
                              ElevatedButton(onPressed: (){},
                                  child: const Text("Change Booking Time", style: TextStyle(fontSize: 20),)
                              )
                            ],
                          )
                        ],
                      )
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}