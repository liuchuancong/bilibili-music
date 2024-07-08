import 'route_path.dart';
import 'package:get/get.dart';
import 'package:bilibilimusic/modules/home/home.dart';

// auth

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: RoutePath.kInitial,
      page: HomePage.new,
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),
  ];
}
