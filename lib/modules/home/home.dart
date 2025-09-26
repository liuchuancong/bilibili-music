import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/plugins/utils.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/widgets/empty_view.dart';
import 'package:bilibilimusic/widgets/menu_button.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/modules/search/search_page.dart';
import 'package:bilibilimusic/modules/home/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  Future<void> addMusicAlbum() async {
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
    return Scaffold(
      appBar: AppBar(
        leading: const MenuButton(),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: '歌单'),
            Tab(text: '关注'),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(RoutePath.kSearch);
              },
              icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              addMusicAlbum();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [MuiscGridView(), FavoriteView()],
      ),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}

class MuiscGridView extends GetView<HomeController> {
  const MuiscGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

class FavoriteView extends GetView<HomeController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() => controller.settingsService.followers.isNotEmpty
              ? MasonryGridView.count(
                  padding: const EdgeInsets.all(5),
                  controller: controller.scrollController,
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: controller.settingsService.followers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed(RoutePath.kProfile, arguments: controller.settingsService.followers[index]);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(controller.settingsService.followers[index].face),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            controller.settingsService.followers[index].name,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const EmptyView(
                  icon: Icons.search,
                  title: "暂无数据",
                  subtitle: "请尝试搜索关注",
                )),
        ),
      ],
    );
  }
}
