import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:northern_delights_app/screens/direction_screen.dart';

String? gastroName;

class GastropubInfo extends StatefulWidget {
  GastropubInfo({
    required this.gastropubID,
    super.key,
  });

  final String gastropubID;


  @override
  _GastropubInfoState createState() => _GastropubInfoState();
}

class _GastropubInfoState extends State<GastropubInfo> {
  final ScrollController _scrollController = ScrollController();
  bool _showCircularButton = false;

  double? gastroLat;
  double? gastroLong;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 60) {
        setState(() {
          _showCircularButton = true;
        });
      } else {
        setState(() {
          _showCircularButton = false;
        });
      }
    });
    _incrementViewCount();
  }

  // For adding view count
  void _incrementViewCount() async {
    try {
      await FirebaseFirestore.instance
          .collection('gastropubs')
          .doc(widget.gastropubID)
          .update({
        'gastro_view_count': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing view count: $e');
    }
  }

  // Function to update restaurant coordinates
  void _updateCoordinates(double lat, double long) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        gastroLat = lat;
        gastroLong = long;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('gastropubs')
                .doc(widget.gastropubID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var gastro = snapshot.data!.data() as Map<String, dynamic>;
              String gastroOverview = gastro['gastro_overview'] ?? '';
              gastroName = gastro['gastro_name'];

              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    FoodPlaceInfoWidget(
                      gastroID: widget.gastropubID,
                      onLocationUpdated: _updateCoordinates, // Pass the callback
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 20),
                            ),
                          ),
                          child: Text('Overview'),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all(Colors.black45),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 18),
                            ),
                          ),
                          child: Text('Menu'),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all(Colors.black45),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 18),
                            ),
                          ),
                          child: Text('Review'),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all(Colors.black45),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 18),
                            ),
                          ),
                          child: Text('Details'),
                        ),
                      ],
                    ),
                    _buildText(gastroOverview), // Use the regular text widget
                    SizedBox(height: 200), // Add space to prevent clipping
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: _showCircularButton
                ? Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {},
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                  ),
                ),
              ),
            )
                : _buildFullWidthButton(),
          ),
        ],
      ),
    );
  }

  // Full-width ElevatedButton
  Widget _buildFullWidthButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SizedBox(
        width: (double.infinity) - 100,
        child: ElevatedButton(
          onPressed: () {
            if (gastroLat != null && gastroLong != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DirectionsMapScreen(
                    destinationLat: gastroLat!,
                    destinationLong: gastroLong!,
                    destinationName: gastroName!,
                  ),
                ),
              );
            } else {
              // Handle case where coordinates are not available
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Change background color
            padding: EdgeInsets.symmetric(
                vertical: 15.0, horizontal: 24.0), // Change padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Change border radius
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Direction',
                style: TextStyle(
                  fontSize: 22, // Change font size
                  fontWeight: FontWeight.bold, // Change font weight
                  fontFamily: 'Roboto', // Change font family
                  color: Colors.white, // Change text color
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.navigation, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  // Regular Text Widget
  Widget _buildText(String gastroOverview) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        gastroOverview,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }
}

class FoodPlaceInfoWidget extends StatelessWidget {
  const FoodPlaceInfoWidget({
    required this.gastroID,
    required this.onLocationUpdated, // Accept the callback
    super.key,
  });

  final String gastroID;
  final Function(double lat, double long) onLocationUpdated; // Callback definition

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('gastropubs')
          .doc(gastroID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var gastro = snapshot.data!.data() as Map<String, dynamic>;
        double screenWidth = MediaQuery.of(context).size.width;


        GeoPoint geoPoint = gastro['gastro_geopoint'];
        double lat = geoPoint.latitude;
        double long = geoPoint.longitude;

        // Call the callback to update the parent widget's state
        onLocationUpdated(lat, long);

        return Container(
          margin: EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Image container
              Container(
                width: screenWidth - 40, // Leave space for margin
                height: 450,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0.0, 4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    gastro['gastro_image_url'], // Use the image URL from Firestore
                    fit: BoxFit.cover,
                    width: 220,
                    height: 300,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.error, // Fallback if the image can't load
                          size: 220,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Info box aligned to the bottom center of the image
              Positioned(
                bottom: 15,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: 330,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.01),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gastro['gastro_name'], // Display the restaurant name
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              gastro['gastro_location'], // Display the restaurant address
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
