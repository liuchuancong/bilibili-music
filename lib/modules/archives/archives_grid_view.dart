import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/modules/playlist/playlist.dart';
import 'package:bilibilimusic/modules/archives/archives_grid_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ArchivesGridView extends StatefulWidget {
  const ArchivesGridView({super.key, required this.tag});
  final String tag;

  @override
  State<ArchivesGridView> createState() => _ArchivesGridViewState();
}

class _ArchivesGridViewState extends State<ArchivesGridView> {
  ArchivesGridController get controller => Get.find<ArchivesGridController>(tag: widget.tag);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final width = constraint.maxWidth;
        final crossAxisCount = width > 1280 ? 5 : (width > 960 ? 4 : (width > 640 ? 3 : 2));
        return Obx(() => EasyRefresh(
            controller: controller.easyRefreshController,
            onRefresh: controller.refreshData,
            onLoad: controller.loadData,
            child: MasonryGridView.count(
              padding: const EdgeInsets.all(5),
              controller: controller.scrollController,
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10,
              itemCount: controller.list.length,
              itemBuilder: (context, index) => SimpleVideoCard(
                mediaInfo: controller.list[index],
                onTap: () {
                  var e = controller.list.value[index];
                  AppNavigator.toLiveRoomDetailList(
                    bilibiliVideo: BilibiliVideo(
                      aid: e.aid,
                      bvid: e.bvid,
                      title: e.title,
                      pic: e.pic,
                      author: e.part,
                    ),
                    mediaType: VideoMediaTypes.masterpiece,
                  );
                },
              ),
            )));
      },
    );
  }
}
