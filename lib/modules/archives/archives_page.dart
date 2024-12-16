import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/play/bottom_music_control.dart';
import 'package:bilibilimusic/modules/archives/archives_grid_view.dart';
import 'package:bilibilimusic/modules/archives/archives_controller.dart';
import 'package:bilibilimusic/modules/archives/archives_grid_controller.dart';

class ArchivesPage extends GetView<ArchivesController> {
  const ArchivesPage({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> operater = ['播放全部'];
    return LayoutBuilder(builder: (context, constraint) {
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: TabBar(
            controller: controller.tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: controller.seriesLiveList
                .map((e) => SizedBox(
                      width: 120,
                      child: Tab(text: e.name),
                    ))
                .toList(),
          ),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (context) => operater.map((quality) {
                return PopupMenuItem<String>(
                  value: quality,
                  child: Text(quality, style: Get.textTheme.bodySmall),
                );
              }).toList(),
              tooltip: '更多',
              color: Get.theme.colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              offset: const Offset(0.0, 5.0),
              position: PopupMenuPosition.under,
              onSelected: (value) {
                if (value == '播放全部') {
                  var gridController = Get.find<ArchivesGridController>(
                      tag: controller.seriesLiveList[controller.tabController.index].sessionId.toString());
                  if (gridController.list.isNotEmpty) {
                    var first = gridController.list.first;
                    AppNavigator.toLiveRoomDetailList(
                      bilibiliVideo: BilibiliVideo(
                        aid: first.aid,
                        bvid: first.bvid,
                        title: first.title,
                        id: first.aid,
                        favorites: first.favorite,
                        pic: first.pic,
                        pubdate: first.pubdate,
                        author: first.name,
                        upic: first.face,
                        status: VideoStatus.series,
                      ),
                      mediaType: VideoMediaTypes.series,
                    );
                  }
                }
              },
              icon: const Icon(Icons.more_horiz),
            )
          ],
        ),
        body: TabBarView(
          controller: controller.tabController,
          children: controller.seriesLiveList
              .map((SeriesLiveMedia e) => ArchivesGridView(
                    tag: e.sessionId.toString(),
                  ))
              .toList(),
        ),
        bottomNavigationBar: const BottomMusicControl(),
      );
    });
  }
}
