import 'package:get/get.dart';
import 'package:bilibilimusic/modules/live_play/live_play_controller.dart';

class LivePlayBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => LivePlayController(
            videoInfo: Get.arguments,
          ))
    ];
  }
}
