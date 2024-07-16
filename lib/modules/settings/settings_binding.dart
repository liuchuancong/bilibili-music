import 'package:get/get.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class SettingsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => SettingsService())];
  }
}
