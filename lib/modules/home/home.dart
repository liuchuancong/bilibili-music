import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/plugins/utils.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/widgets/empty_view.dart';
import 'package:bilibilimusic/widgets/menu_button.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/modules/search/search_page.dart';
import 'package:bilibilimusic/modules/home/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuButton(),
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(RoutePath.kSearch);
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: const MuiscGridView(),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}

class MuiscGridView extends GetView<HomeController> {
  const MuiscGridView({super.key});

  addMusicAlbum() async {
    Map<String, String?>? result = await Utils.showEditDialog();
    if (result != null) {
      controller.settingsService.addMusicAlbum(
        BilibiliVideo(
          id: Utils.getRandomId(),
          title: result['title'],
          author: result['author'],
          pubdate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          status: VideoStatus.customized,
          play: 0,
          favorites: 0,
        ),
        [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  addMusicAlbum();
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Obx(() => controller.settingsService.musicAlbum.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: controller.settingsService.musicAlbum.length,
                  itemBuilder: (context, index) {
                    return RoomCard(
                      bilibiliVideo: controller.settingsService.musicAlbum[index],
                      isVideo: false,
                      showTrailing: true,
                    );
                  },
                ),
              )
            : const EmptyView(
                icon: Icons.search,
                title: "暂无数据",
                subtitle: "请尝试搜索关注",
              )),
      ],
    );
  }
}
