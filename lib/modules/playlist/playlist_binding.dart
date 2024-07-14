import 'package:get/get.dart';
import 'playlist_controller.dart';

class PlayListBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => PlayListController(
            bilibiliVideo: Get.arguments,
          ))
    ];
  }
}
