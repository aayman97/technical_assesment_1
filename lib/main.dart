import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  
  
  Future<void> getCurrentLocation () async {
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
print(_locationData);
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
              top : 0,
              left: (width*0.1)/2,
              child: Container(
                  decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/maps.jpg'),
            fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(width: 2, color: Colors.white)
        ),
              height: height*0.9,
             width: width*0.9,
              )
              ),
              Positioned(
                top : height*0.78,
                left : (width*0.3)/2,
                child: GestureDetector(
                  onTap: () {
                   getCurrentLocation();
                  },
                  child: Container(
                    height: height*0.1,
                    width: width*0.7,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffbdc3c7),
                 Color(0xff2c3e50),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Center(
                      child: Text("My Current Location", style: TextStyle(
                                                              color: Colors.white.withOpacity(1.0),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                               
                            ),
                            )
                      
                      ),
                  ),
                ),
              )
          ],
        ),
      )
    );
  }
}
