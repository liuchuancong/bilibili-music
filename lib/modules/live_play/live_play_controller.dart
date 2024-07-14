import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/live_video_info.dart';
import 'package:bilibilimusic/modules/live_play/widgets/video_player/video_controller.dart';

class LivePlayController extends StateController {
  // 控制唯一子组件
  VideoController? videoController;
  final VideoInfo videoInfo;

  LivePlayController({required this.videoInfo});

  var success = false.obs;
  int lastExitTime = 0;
  int position = 0;

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
      videoController = VideoController(videoInfo: videoInfo, videoInfoData: videoInfoData, initPosition: 0);
    }
  }

  void setResolution(String quality) async {
    if (videoController != null && !videoController!.hasDestory.value) {
      position = videoController!.position.value;
      videoController!.destory();
      success.value = false;
    }

    var detail = await BiliBiliSite().getVideoDetail(videoInfo.aid, videoInfo.cid, videoInfo.bvid, qn: quality);
    if (detail != null) {
      videoInfoData = detail;
      success.value = true;
      videoController = VideoController(videoInfo: videoInfo, videoInfoData: videoInfoData, initPosition: position);
    }
  }

  Future<bool> onBackPressed() async {
    if (videoController!.isFullscreen.value) {
      videoController?.exitFullScreen();
      return await Future.value(false);
    }
    int nowExitTime = DateTime.now().millisecondsSinceEpoch;
    if (nowExitTime - lastExitTime > 1000) {
      lastExitTime = nowExitTime;
      SmartDialog.showToast("再按一次退出");
      return await Future.value(false);
    }
    videoController!.destory();
    return await Future.value(true);
  }
}
