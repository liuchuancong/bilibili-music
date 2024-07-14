import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/services/bilibili_account_service.dart';
import 'package:bilibilimusic/modules/account/account_controller.dart';

class HomePage extends GetView<AccountController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bilibili Music"), centerTitle: true, actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(RoutePath.kSearch);
            },
            icon: const Icon(Icons.search))
      ]),
      body: ListView(
        children: [
          Obx(
            () => ListTile(
              leading: Image.asset(
                'assets/images/bilibili_2.png',
                width: 36,
                height: 36,
              ),
              title: const Text("哔哩哔哩"),
              subtitle: Text(BiliBiliAccountService.instance.name.value),
              trailing: BiliBiliAccountService.instance.logined.value
                  ? const Icon(Icons.logout)
                  : const Icon(Icons.chevron_right),
              onTap: controller.bilibiliTap,
            ),
          ),
        ],
      ),
    );
  }
}
