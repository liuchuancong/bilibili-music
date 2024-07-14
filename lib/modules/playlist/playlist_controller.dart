import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/models/live_video_info.dart';

class PlayListController extends BasePageController {
  final BilibiliVideo bilibiliVideo;
  PlayListController({required this.bilibiliVideo});

  @override
  Future<List<VideoInfo>> getData(int page, int pageSize) async {
    var result = await BiliBiliSite().getRoomListDetail(bilibiliVideo.bvid!);

    return result;
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}
