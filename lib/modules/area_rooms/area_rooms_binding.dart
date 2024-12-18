import 'package:get/get.dart';
import 'package:bilibilimusic/modules/area_rooms/area_rooms_controller.dart';

class AreaRoomsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => AreaRoomsController(upUserInfo: Get.arguments[0]))];
  }
}
