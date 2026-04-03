import 'package:get/get.dart';

class GlobalPlayerState extends GetxController {
  static GlobalPlayerState get to => Get.find<GlobalPlayerState>();
  var isFullscreen = false.obs;
  var isPipMode = false.obs;
  bool get fullscreenUI => isFullscreen.value;
  void reset() {
    isFullscreen.value = false;
  }

  String? _currentRoomId;
  void setCurrentRoom(String roomId) {
    if (_currentRoomId != roomId) {
      _currentRoomId = roomId;
    }
  }
}
