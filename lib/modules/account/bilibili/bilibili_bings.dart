import 'package:get/get.dart';
import 'package:bilibilimusic/modules/account/bilibili/qr_login_controller.dart';
import 'package:bilibilimusic/modules/account/bilibili/web_login_controller.dart';

class BilibiliWebLoginBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => BiliBiliWebLoginController()),
    ];
  }
}

class BilibiliQrLoginBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => BiliBiliQRLoginController()),
    ];
  }
}
