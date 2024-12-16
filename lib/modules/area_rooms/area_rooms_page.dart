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
    return Scaffold(
      appBar: AppBar(
        title: const Text('TA的视频'),
        actions: [IconButton(icon: const Icon(Icons.playlist_add_check), onPressed: () {})],
      ),
      bottomNavigationBar: const BottomMusicControl(),
      body: LayoutBuilder(builder: (context, constraint) {
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
            ));
      }),
    );
  }
}
