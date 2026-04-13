import 'package:get/get.dart';
import 'package:bilibilimusic/modules/version/version_controller.dart';

class VersionBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => VersionController())];
  }
}
