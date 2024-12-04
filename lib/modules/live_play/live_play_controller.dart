import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:bilibilimusic/modules/live_play/widgets/video_player/video_controller.dart';

class LivePlayController extends StateController {
  // 控制唯一子组件
  VideoController? videoController;
  final LiveMediaInfo mediaInfo;
  SettingsService settingsService = Get.find<SettingsService>();
  LivePlayController({required this.mediaInfo});

  var success = false.obs;
  int lastExitTime = 0;
  int position = 0;
  final AudioController audioController = Get.find<AudioController>();
  late LiveMediaInfoData videoInfoData;
  @override
  void onInit() {
    onInitPlayer();
    if (audioController.isPlaying.value) {
      audioController.pause();
    }
    super.onInit();
  }

  @override
  void onClose() async {
    if (videoController != null && !videoController!.hasDestory.value) {
      position = 0;
      await videoController!.destory();
      success.value = false;
    }
    audioController.play();
    super.onClose();
  }

  Future onInitPlayer() async {
    var detail = await BiliBiliSite().getVideoDetail(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
    if (detail != null) {
      videoInfoData = detail;
      success.value = true;
      videoController = VideoController(mediaInfo: mediaInfo, videoInfoData: videoInfoData, initPosition: 0);
    }
  }

  void setResolution(String quality) async {
    if (videoController != null && !videoController!.hasDestory.value) {
      position = videoController!.position.value;
      videoController!.destory();
      success.value = false;
    }

    var detail = await BiliBiliSite().getVideoDetail(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid, qn: quality);
    if (detail != null) {
      videoInfoData = detail;
      success.value = true;
      videoController = VideoController(mediaInfo: mediaInfo, videoInfoData: videoInfoData, initPosition: position);
    }
  }

  void playNext() async {
    if (videoController != null && !videoController!.hasDestory.value) {
      position = 0;
      videoController!.destory();
      success.value = false;
    }

    var nextVideoInfo = settingsService.getNextVideoInfo();

    var detail = await BiliBiliSite().getVideoDetail(nextVideoInfo.aid, nextVideoInfo.cid, nextVideoInfo.bvid);
    if (detail != null) {
      videoInfoData = detail;
      success.value = true;
      videoController = VideoController(mediaInfo: nextVideoInfo, videoInfoData: videoInfoData, initPosition: 0);
    }
  }

  void replay() async {
    if (videoController != null && !videoController!.hasDestory.value) {
      position = 0;
      videoController!.destory();
      success.value = false;
    }

    var nextVideoInfo = settingsService.getCurrentVideoInfo();
    var detail = await BiliBiliSite().getVideoDetail(nextVideoInfo.aid, nextVideoInfo.cid, nextVideoInfo.bvid);
    if (detail != null) {
      videoInfoData = detail;
      success.value = true;
      videoController = VideoController(mediaInfo: nextVideoInfo, videoInfoData: videoInfoData, initPosition: 0);
    }
  }

  void playPrevious() async {
    if (videoController != null && !videoController!.hasDestory.value) {
      position = 0;
      videoController!.destory();
      success.value = false;
    }

    var previousVideoInfo = settingsService.getPreviousVideoInfo();

    var detail =
        await BiliBiliSite().getVideoDetail(previousVideoInfo.aid, previousVideoInfo.cid, previousVideoInfo.bvid);
    if (detail != null) {
      videoInfoData = detail;
      success.value = true;
      videoController = VideoController(mediaInfo: previousVideoInfo, videoInfoData: videoInfoData, initPosition: 0);
    }
  }

  void playByVideoInfo(LiveMediaInfo mediaInfo) async {
    if (videoController != null && !videoController!.hasDestory.value) {
      position = 0;
      videoController!.destory();
      success.value = false;
    }
    var detail = await BiliBiliSite().getVideoDetail(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
    if (detail != null) {
      videoInfoData = detail;
      success.value = true;
      settingsService.setCurrentMedia(mediaInfo);
      videoController = VideoController(mediaInfo: mediaInfo, videoInfoData: videoInfoData, initPosition: 0);
    }
  }

  Future<bool> onBackPressed() async {
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
