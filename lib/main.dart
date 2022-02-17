import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:technical_assesment_1/map.dart';

import 'controller/stateController.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LocationData _location;
  final StateController stateController = Get.put(StateController());

  Future<void> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    stateController.setCurrentLocation(_locationData);
    setState(() {
      _location = _locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: (width * 0.1) / 2,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/maps.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 2, color: Colors.white)),
                height: height * 0.9,
                width: width * 0.9,
              )),
          AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              top: 100,
              left: stateController.confrimed ? width * 0.1 : width,
              child: Container(
                height: height * 0.15,
                width: width * 0.8,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xffbdc3c7),
                        Color(0xff2c3e50),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "My Current Location",
                      style: TextStyle(fontSize: 25),
                    ),
                    stateController.confrimed
                        ? Column(
                            children: [
                              Text("Latitude: " +
                                  stateController.currentLoction.latitude
                                      .toString()),
                              Text("Longitude: " +
                                  stateController.currentLoction.longitude
                                      .toString()),
                            ],
                          )
                        : Text("No Current location"),
                  ],
                ),
              )),
          Positioned(
            top: height * 0.78,
            left: (width * 0.3) / 2,
            child: GestureDetector(
              onTap: () {
                getCurrentLocation().then((value) {
                  Get.off(
                      MapScreen(
                        location: _location,
                      ),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 500));
                });
              },
              child: Container(
                height: height * 0.1,
                width: width * 0.7,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xffbdc3c7),
                        Color(0xff2c3e50),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Center(
                    child: Text(
                  "My Current Location",
                  style: TextStyle(
                    color: Colors.white.withOpacity(1.0),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                )),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
