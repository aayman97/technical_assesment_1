import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technical_assesment_1/main.dart';

import 'controller/stateController.dart';

class MapScreen extends StatefulWidget {
  final LocationData location;
  const MapScreen({Key? key, required this.location}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState(location);
}

class _MapScreenState extends State<MapScreen> {
  late final LocationData location;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final StateController stateController = Get.put(StateController());

  bool _loading = true;

  late CameraPosition _kGooglePlex;
  late Timer _timer;
  int _start = 2;
  bool _displayConfirm = false;
  _MapScreenState(this.location);

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  void startTimer() {
    print("loading ...." + stateController.currentLoction.longitude.toString());
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _loading = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();

    _kGooglePlex = CameraPosition(
      target: LatLng(stateController.currentLoction.latitude!,
          stateController.currentLoction.longitude!),
      zoom: 14.4746,
    );
    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(stateController.currentLoction.latitude!,
          stateController.currentLoction.longitude!),
      // icon: BitmapDescriptor.,

      onTap: () {
        setState(() {
          _displayConfirm = true;
        });
      },
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: width,
            height: height,
            child: _loading
                ? Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballRotateChase,

                          /// Required, The loading type of the widget
                          colors: const [
                            Colors.pink,
                            Colors.red,
                            Colors.green,
                            Colors.orange,
                            Colors.blue
                          ],

                          /// Optional, The color collections
                          strokeWidth: 2,

                          /// Optional, The stroke of the line, only applicable to widget which contains line
                        ),
                      ),
                    ),
                  )
                : GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: markers.values.toSet(),
                    myLocationButtonEnabled: false,
                  ),
          ),
          AnimatedPositioned(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 500),
              top: _displayConfirm ? (height * 0.75) / 7 : (height * 1),
              left: width * 0.1,
              child: Container(
                height: height * 0.25,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Is This your current location ?",
                          style: TextStyle(fontSize: 17, color: Colors.black45),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            stateController.setConfirmed();
                            Get.off(MyHomePage());
                          },
                          child: Container(
                            width: width * 0.3,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xff2193b0),
                                    Color(0xff6dd5ed),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Center(
                              child: Text(
                                "Yes !",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _displayConfirm = false;
                          },
                          child: Container(
                            width: width * 0.3,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xffcc2b5e),
                                    Color(0xff753a88),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
      floatingActionButton: _loading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                child: Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotateChase,

                    /// Required, The loading type of the widget
                    colors: const [Colors.transparent],

                    /// Optional, The color collections
                    strokeWidth: 2,

                    /// Optional, The stroke of the line, only applicable to widget which contains line
                  ),
                ),
              ),
            )
          : FloatingActionButton(
              onPressed: _goToCurrentPosition,
              child: Icon(Icons.location_on),
            ),
    );
  }
}
