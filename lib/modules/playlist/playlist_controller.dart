import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/models/live_video_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class PlayListController extends BasePageController {
  final BilibiliVideo bilibiliVideo;
  PlayListController({required this.bilibiliVideo});
  SettingsService settingsService = Get.find<SettingsService>();
  @override
  Future<List<VideoInfo>> getData(int page, int pageSize) async {
    var result = await BiliBiliSite().getRoomListDetail(bilibiliVideo.bvid!);
    return result;
  }

  @override
  void onInit() {
    list.listen((p0) {
      settingsService.videoInfos = list;
    });
    loadData();
    super.onInit();
  }
}
