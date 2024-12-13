import 'package:get/get.dart';
import 'package:bilibilimusic/modules/profile/profile_controll.dart';

class ProfileBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => ProfileController(
            upUserInfo: Get.arguments,
          ))
    ];
  }
}
