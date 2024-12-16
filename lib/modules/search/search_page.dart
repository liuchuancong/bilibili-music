import 'dart:ui';
import 'dart:developer';
import 'package:get/get.dart';
import 'search_controller.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/plugins/utils.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:bilibilimusic/widgets/empty_view.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
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
                      icon: Icons.search,
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
    this.isVideo = false,
    this.showTrailing = false,
  });

  final BilibiliVideo bilibiliVideo;
  final bool isVideo;
  final bool showTrailing;
  void onTap() async {
    VideoMediaTypes mediaType = VideoMediaTypes.masterpiece;
    if (bilibiliVideo.status == VideoStatus.series) {
      mediaType = VideoMediaTypes.series;
    } else if (bilibiliVideo.status == VideoStatus.customized) {
      mediaType = VideoMediaTypes.customized;
    } else if (bilibiliVideo.status == VideoStatus.published) {
      mediaType = VideoMediaTypes.masterpiece;
    } else {
      mediaType = VideoMediaTypes.allVideos;
    }
    AppNavigator.toLiveRoomDetailList(
      bilibiliVideo: bilibiliVideo,
      mediaType: mediaType,
    );
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
        child: Stack(
          children: [
            SizedBox(
              height: 100,
              child: Card(
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).focusColor,
                elevation: 0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    bilibiliVideo.status == VideoStatus.published
                        ? CachedNetworkImage(
                            imageUrl: bilibiliVideo.pic!.startsWith("http")
                                ? bilibiliVideo.pic!
                                : "http:${bilibiliVideo.pic}",
                            cacheManager: CustomCacheManager.instance,
                            fit: BoxFit.fill,
                            errorWidget: (context, error, stackTrace) => const Center(
                              child: Icon(
                                Icons.music_note_rounded,
                                size: 20,
                              ),
                            ),
                          )
                        : Container(),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        decoration: bilibiliVideo.status == VideoStatus.customized
                            ? const BoxDecoration(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                border: Border(top: BorderSide(color: Colors.black26, width: 1)),
                                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                  Colors.black,
                                  Colors.black87,
                                  Colors.black54,
                                  Colors.black87,
                                  Colors.black,
                                ]),
                              )
                            : null,
                        color: bilibiliVideo.status == VideoStatus.published
                            ? Colors.black.withOpacity(0)
                            : null, // Adjust the opacity as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: ListTile(
                  leading: bilibiliVideo.status == VideoStatus.published || bilibiliVideo.status == VideoStatus.series
                      ? CircleAvatar(
                          foregroundImage: bilibiliVideo.upic!.isNotEmpty ? getRoomAvatar(bilibiliVideo.upic) : null,
                          backgroundColor: Theme.of(context).disabledColor,
                        )
                      : const Icon(
                          Icons.album_rounded,
                          color: Colors.white,
                        ),
                  title: SizedBox(
                    height: 50,
                    child: Text(
                      bilibiliVideo.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    '${bilibiliVideo.author!.isEmpty ? "未知" : bilibiliVideo.author} - ${transformData(bilibiliVideo.pubdate!)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  trailing: showTrailing
                      ? IconButton(
                          onPressed: () {
                            handleMore();
                          },
                          icon: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.white),
                        )
                      : null,
                ),
              ),
            ),
            if (bilibiliVideo.status == VideoStatus.published)
              Positioned(
                right: 2,
                bottom: 2,
                child: CountChip(
                  icon: Icons.play_arrow_rounded,
                  count: readableCount(bilibiliVideo.play.toString()),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }

  handleMore() async {
    var result = await Utils.showBottomSheet();
    final settings = Get.find<SettingsService>();
    if (result == '1') {
      settings.moveMusicToTop(bilibiliVideo);
    } else if (result == '2') {
      editMuiscAlbum();
    } else if (result == '3') {
      if (bilibiliVideo.id == settings.favoriteId) {
        SmartDialog.showToast("系统预设不允许删除");
      } else {
        settings.removeMusicAlbum(bilibiliVideo);
      }
    }
  }

  editMuiscAlbum() async {
    final settings = Get.find<SettingsService>();
    Map<String, String?>? result =
        await Utils.showEditDialog(isEdit: true, title: bilibiliVideo.title!, author: bilibiliVideo.author!);
    if (result != null) {
      settings.editMusicAlbum(
        BilibiliVideo(
          id: bilibiliVideo.id,
          title: result['title'],
          author: result['author'],
        ),
      );
    }
  }
}

class CountChip extends StatelessWidget {
  const CountChip({
    super.key,
    required this.icon,
    required this.count,
    this.color = Colors.black,
  });

  final IconData icon;
  final String count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: color.withOpacity(0.8),
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 14,
            ),
            Text(
              count.isEmpty ? '0' : count,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
