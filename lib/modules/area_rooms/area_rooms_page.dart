import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/modules/playlist/playlist.dart';
import 'package:bilibilimusic/modules/area_rooms/area_rooms_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AreasRoomPage extends StatefulWidget {
  const AreasRoomPage({super.key});

  @override
  State<AreasRoomPage> createState() => _AreasRoomPageState();
}

class _AreasRoomPageState extends State<AreasRoomPage> {
  AreaRoomsController get controller => Get.find<AreaRoomsController>();

  @override
  void initState() {
    super.initState();
    controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    // List<String> operater = ['播放全部'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('TA的视频'),
        actions: const [
          // PopupMenuButton<String>(
          //   itemBuilder: (context) => operater.map((quality) {
          //     return PopupMenuItem<String>(
          //       value: quality,
          //       child: Text(quality, style: Get.textTheme.bodySmall),
          //     );
          //   }).toList(),
          //   tooltip: '更多',
          //   color: Get.theme.colorScheme.surfaceContainerHighest,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   offset: const Offset(0.0, 5.0),
          //   position: PopupMenuPosition.under,
          //   onSelected: (value) {
          //     if (value == '播放全部') {
          //       var first = controller.list.first;
          //       AppNavigator.toLiveRoomDetailList(
          //         bilibiliVideo: BilibiliVideo(
          //           aid: first.aid,
          //           bvid: first.bvid,
          //           title: first.title,
          //           id: first.aid,
          //           favorites: first.favorite,
          //           pic: first.pic,
          //           pubdate: first.pubdate,
          //           author: controller.upUserInfo.name,
          //           upic: controller.upUserInfo.face,
          //           status: VideoStatus.allVideos,
          //           mid: controller.upUserInfo.mid,
          //         ),
          //         mediaType: VideoMediaTypes.allVideos,
          //       );
          //     }
          //   },
          //   icon: const Icon(Icons.more_horiz),
          // )
        ],
      ),
      bottomNavigationBar: const BottomMusicControl(),
      body: LayoutBuilder(builder: (context, constraint) {
        final width = constraint.maxWidth;
        final crossAxisCount = width > 1280 ? 5 : (width > 960 ? 4 : (width > 640 ? 3 : 2));
        return Obx(
          () => EasyRefresh(
            controller: controller.easyRefreshController,
            onRefresh: controller.refreshData,
            onLoad: controller.loadData,
            child: MasonryGridView.count(
              padding: const EdgeInsets.all(5),
              controller: controller.scrollController,
              crossAxisCount: crossAxisCount,
              itemCount: controller.list.length,
              mainAxisSpacing: 10,
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
            ),
          ),
        );
      }),
    );
  }
}
