import 'dart:developer';
import 'package:get/get.dart';
import 'search_controller.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/widgets/empty_view.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPage extends GetView<SearchMusicController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: controller.searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "搜索",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            prefixIcon: IconButton(
              onPressed: () {
                Navigator.of(Get.context!).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            suffixIcon: IconButton(
              onPressed: controller.doSearch,
              icon: const Icon(Icons.search),
            ),
          ),
          onSubmitted: (e) {
            controller.doSearch();
          },
        ),
        bottom: TabBar(
          controller: controller.tabController,
          padding: EdgeInsets.zero,
          tabAlignment: TabAlignment.center,
          tabs: controller.tabList.map((e) => Tab(text: e)).toList(),
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        final width = constraint.maxWidth;
        final crossAxisCount = width > 1280 ? 4 : (width > 960 ? 3 : (width > 640 ? 2 : 1));
        return Obx(() => EasyRefresh(
              controller: controller.easyRefreshController,
              onRefresh: controller.refreshData,
              onLoad: controller.loadData,
              child: controller.list.isNotEmpty
                  ? MasonryGridView.count(
                      padding: const EdgeInsets.all(8),
                      physics: const BouncingScrollPhysics(),
                      controller: controller.scrollController,
                      crossAxisCount: crossAxisCount,
                      itemCount: controller.list.length,
                      itemBuilder: (context, index) {
                        return RoomCard(bilibiliVideo: controller.list[index]);
                      },
                    )
                  : const EmptyView(
                      icon: Icons.error_outline,
                      title: "暂无搜索结果",
                      subtitle: "请尝试更换关键词或稍后再试",
                    ),
            ));
      }),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.bilibiliVideo,
    this.dense = false,
  });
  final BilibiliVideo bilibiliVideo;
  final bool dense;

  void onTap() async {
    AppNavigator.toLiveRoomDetailList(bilibiliVideo: bilibiliVideo);
  }

  ImageProvider? getRoomAvatar(avatar) {
    try {
      return CachedNetworkImageProvider(avatar, errorListener: (err) {
        log("CachedNetworkImageProvider: Image failed to load!");
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(7.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () => onTap(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: Theme.of(context).focusColor,
                    elevation: 0,
                    child: CachedNetworkImage(
                      imageUrl:
                          bilibiliVideo.pic!.startsWith("http") ? bilibiliVideo.pic! : "http:${bilibiliVideo.pic}",
                      cacheManager: CustomCacheManager.instance,
                      fit: BoxFit.fill,
                      errorWidget: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.live_tv_rounded,
                          size: dense ? 38 : 62,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: dense ? 0 : 2,
                  top: dense ? 0 : 2,
                  child: CountChip(
                    icon: Icons.video_collection_rounded,
                    count: readableCount(bilibiliVideo.play.toString()),
                    dense: dense,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            ListTile(
              dense: dense,
              minLeadingWidth: 34,
              contentPadding: const EdgeInsets.only(left: 8, right: 10),
              horizontalTitleGap: 8,
              leading: CircleAvatar(
                foregroundImage: bilibiliVideo.upic!.isNotEmpty ? getRoomAvatar(bilibiliVideo.upic) : null,
                radius: dense ? 17 : null,
                backgroundColor: Theme.of(context).disabledColor,
              ),
              title: SizedBox(
                height: 50,
                child: Text(
                  bilibiliVideo.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              subtitle: Text(
                '${bilibiliVideo.author} - ${transformData(bilibiliVideo.pubdate!)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: dense ? 12 : 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CountChip extends StatelessWidget {
  const CountChip({
    super.key,
    required this.icon,
    required this.count,
    this.dense = false,
    this.color = Colors.black,
  });

  final IconData icon;
  final String count;
  final bool dense;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: color.withOpacity(0.8),
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(dense ? 4 : 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: dense ? 18 : 20,
            ),
            Text(
              count,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: dense ? 15 : 18,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
