import 'package:get/get.dart';
import 'package:bilibilimusic/modules/history/history_controller.dart';

class HistoryBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => HistoryController())];
  }
}
