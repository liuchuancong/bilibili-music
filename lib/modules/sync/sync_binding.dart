import 'package:get/get.dart';
import 'package:bilibilimusic/modules/sync/sync_controller.dart';

class SyncBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => SyncController())];
  }
}
