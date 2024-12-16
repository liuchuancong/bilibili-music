import 'package:get/get.dart';
import 'package:bilibilimusic/modules/archives/archives_controller.dart';

class ArchivesBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => ArchivesController(
            seriesLiveList: Get.arguments[0],
            upUserInfo: Get.arguments[1],
            sessionId: Get.arguments[2],
          ))
    ];
  }
}
