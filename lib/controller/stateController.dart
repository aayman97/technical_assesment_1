import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:location/location.dart';

class StateController extends GetxController {
  bool confrimed = false;
  late LocationData currentLoction;

  void setConfirmed() {
    confrimed = true;
    update();
  }

  void setCurrentLocation(LocationData l) {
    currentLoction = l;
    update();
  }
}
