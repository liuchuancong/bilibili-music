import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/plugins/utils.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/widgets/music_card.dart';
import 'package:bilibilimusic/widgets/empty_view.dart';
import 'package:bilibilimusic/widgets/menu_button.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bilibilimusic/modules/home/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Future<void> addMusicPlaylist() async {
    Map<String, String?>? result = await Utils.showEditDialog();
    if (result != null) {
      controller.settingsService.addMusicPlaylist(
        BilibiliVideoItem(
          id: Utils.getRandomId(),
          title: result['title'],
          author: result['author'],
          pubdate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          category: VideoCategory.customized,
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
          IconButton(onPressed: () => Get.toNamed(RoutePath.kSearch), icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () => addMusicPlaylist(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller.tabController,
        // These children are now stateful and will keep their state
        children: const [MuiscGridView(), FavoriteView()],
      ),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}

/// --- 1. Music Tab (Playlist) ---
class MuiscGridView extends StatefulWidget {
  const MuiscGridView({super.key});

  @override
  State<MuiscGridView> createState() => _MuiscGridViewState();
}

class _MuiscGridViewState extends State<MuiscGridView> with AutomaticKeepAliveClientMixin {
  final controller = Get.find<HomeController>();

  @override
  bool get wantKeepAlive => true; // Forces the tab to stay in memory

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by Mixin
    return Obx(() => controller.settingsService.musicPlaylists.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.settingsService.musicPlaylists.length,
            itemBuilder: (context, index) {
              return MusicCard(
                bilibiliVideo: controller.settingsService.musicPlaylists[index],
                isVideo: false,
                showTrailing: true,
              );
            },
          )
        : const EmptyView(
            icon: Icons.search,
            title: "暂无数据",
            subtitle: "请尝试添加歌单",
          ));
  }
}

/// --- 2. Followed Tab (Grid) ---
class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> with AutomaticKeepAliveClientMixin {
  final controller = Get.find<HomeController>();

  @override
  bool get wantKeepAlive => true; // Keeps scroll position and data loaded

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by Mixin
    return Obx(() => controller.settingsService.followedUpList.isNotEmpty
        ? MasonryGridView.count(
            padding: const EdgeInsets.all(10),
            controller: controller.scrollController,
            crossAxisCount: 4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            itemCount: controller.settingsService.followedUpList.length,
            itemBuilder: (context, index) {
              final up = controller.settingsService.followedUpList[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Get.toNamed(RoutePath.kProfile, arguments: up),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).focusColor,
                      backgroundImage: CachedNetworkImageProvider(up.face),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      up.name,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          )
        : const EmptyView(
            icon: Icons.people_outline,
            title: "暂无关注",
            subtitle: "去搜索页关注一些 UP 主吧",
          ));
  }
}
