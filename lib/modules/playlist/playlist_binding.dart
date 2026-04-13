import 'package:get/get.dart';
import 'playlist_controller.dart';

class PlayListBinding extends Binding {
  @override
  List<Bind> dependencies() {
    String? tag = Get.parameters['id'];
    return [
      Bind.lazyPut(
        () => PlayListController(
          bilibiliVideo: Get.arguments[0],
          mediaType: Get.arguments[1],
        ),
        tag: tag,
      )
    ];
  }
}
