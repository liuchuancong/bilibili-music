import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/widgets/empty_view.dart';
import 'package:bilibilimusic/widgets/menu_button.dart';
import 'package:bilibilimusic/modules/search/search_page.dart';
import 'package:bilibilimusic/modules/home/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HistoryPage extends GetView<HomeController> {
  const HistoryPage({super.key});

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

class AlbumGridView extends GetView<HomeController> {
  const AlbumGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth;
      int crossAxisCount = width > 1280 ? 4 : (width > 960 ? 3 : (width > 640 ? 2 : 1));
      return Obx(() => controller.settingsService.videoAlbum.isNotEmpty
          ? MasonryGridView.count(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              crossAxisCount: crossAxisCount,
              itemCount: controller.settingsService.videoAlbum.length,
              itemBuilder: (context, index) {
                return RoomCard(bilibiliVideo: controller.settingsService.videoAlbum[index]);
              },
            )
          : const EmptyView(
              icon: Icons.error_outline,
              title: "暂无数据",
              subtitle: "请尝试搜索关注",
            ));
    });
  }
}

class MuiscGridView extends GetView<HomeController> {
  const MuiscGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth;
      int crossAxisCount = width > 1280 ? 4 : (width > 960 ? 3 : (width > 640 ? 2 : 1));
      return Obx(() => controller.settingsService.videoAlbum.isNotEmpty
          ? MasonryGridView.count(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              crossAxisCount: crossAxisCount,
              itemCount: controller.settingsService.videoAlbum.length,
              itemBuilder: (context, index) {
                return RoomCard(bilibiliVideo: controller.settingsService.videoAlbum[index]);
              },
            )
          : const EmptyView(
              icon: Icons.error_outline,
              title: "暂无数据",
              subtitle: "请尝试搜索关注",
            ));
    });
  }
}
