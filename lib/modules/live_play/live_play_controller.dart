import 'package:get/get.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/live_video_info.dart';
import 'package:bilibilimusic/modules/live_play/widgets/video_player/video_controller.dart';

class LivePlayController extends StateController {
  // 控制唯一子组件
  VideoController? videoController;
  final VideoInfo videoInfo;

  LivePlayController({required this.videoInfo});

  var success = false.obs;

  late VideoInfoData videoInfoData;
  @override
  void onInit() {
    onInitPlayer();
    super.onInit();
  }

  Future onInitPlayer() async {
    var detail = await BiliBiliSite().getVideoDetail(videoInfo.aid, videoInfo.cid, videoInfo.bvid);
    if (detail != null) {
      videoInfoData = detail;
      success.value = true;
      videoController = VideoController(videoInfo: videoInfo, videoInfoData: videoInfoData);
    }
  }
}
