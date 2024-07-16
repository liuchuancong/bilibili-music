import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/widgets/empty_view.dart';
import 'package:bilibilimusic/widgets/menu_button.dart';
import 'package:bilibilimusic/modules/search/search_page.dart';
import 'package:bilibilimusic/modules/home/home_controller.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: '视频'),
            Tab(text: '音乐'),
          ],
        ),
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
      body: TabBarView(
        controller: controller.tabController,
        children: const [AlbumGridView(), MuiscGridView()],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: controller.audioController.previous,
                ),
                Obx(() => IconButton(
                      icon: Icon(controller.audioController.isPlaying.value ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        if (controller.audioController.audioPlayer.playing) {
                          controller.audioController.pause();
                        } else {
                          controller.audioController.play();
                        }
                      },
                    )),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: controller.audioController.next,
                ),
              ],
            ),
            Obx(() => ProgressBar(
                  progress: controller.audioController.currentMusicPosition.value,
                  barHeight: 5,
                  thumbRadius: 4,
                  thumbGlowRadius: 8,
                  total: controller.audioController.currentMusicDuration.value,
                  onSeek: (duration) {},
                )),
          ],
        ),
      ),
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
      return Obx(() => controller.settingsService.musicAlbum.isNotEmpty
          ? MasonryGridView.count(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              crossAxisCount: crossAxisCount,
              itemCount: controller.settingsService.musicAlbum.length,
              itemBuilder: (context, index) {
                return RoomCard(bilibiliVideo: controller.settingsService.musicAlbum[index]);
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
