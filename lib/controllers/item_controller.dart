import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ItemController extends GetxController {
  var count = 0.obs;
  increment() => count++;
}
