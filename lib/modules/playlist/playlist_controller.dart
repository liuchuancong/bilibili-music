import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class PlayListController extends BasePageController {
  final BilibiliVideo bilibiliVideo;
  PlayListController({required this.bilibiliVideo});
  SettingsService settingsService = Get.find<SettingsService>();

  final AudioController audioController = Get.find<AudioController>();
  @override
  Future<List<LiveMediaInfo>> getData(int page, int pageSize) async {
    var result = await BiliBiliSite().getRoomListDetail(bilibiliVideo.bvid!);
    return result;
  }

  @override
  void onInit() {
    settingsService.currentVideoIndex.value = 0;
    list.listen((p0) {
      settingsService.videoInfos = list;
    });
    loadData();
    super.onInit();
  }
}
