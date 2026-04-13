import 'dart:async';
import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/bili_up_info.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class PlayListController extends BasePageController<VideoMediaInfo> {
  final BilibiliVideoItem bilibiliVideo;
  final VideoMediaType mediaType;

  PlayListController({
    required this.bilibiliVideo,
    required this.mediaType,
  })  : currentbilibiliVideo = bilibiliVideo,
        currentMediaType = mediaType;

  AppSettingsService settingsService = Get.find<AppSettingsService>();
  StreamSubscription<dynamic>? subscription;

  /// 多选控制器（你要的官方库）
  final MultiSelectController<int> multiSelectController = MultiSelectController();
  var showSelectBox = false.obs;

  var oid = "".obs;
  var upUserInfo = BiliUpInfo().obs;

  BilibiliVideoItem currentbilibiliVideo;
  VideoMediaType currentMediaType;

  final AudioController audioController = Get.find<AudioController>();

  var isAllSelected = false.obs;

  @override
  Future<List<VideoMediaInfo>> getData(int page, int pageSize) async {
    List<VideoMediaInfo> playitems = [];
    if (currentbilibiliVideo.category == VideoCategory.customized) {
      if (list.isNotEmpty) return [];
      playitems.addAll(currentbilibiliVideo.medias);
      return playitems;
    } else if (currentMediaType == VideoMediaType.masterpiece) {
      if (list.isNotEmpty) return [];
      var result = await BiliBiliSite().getRoomListDetail(currentbilibiliVideo.bvid!);
      playitems.addAll(result);
      return playitems;
    } else if (currentMediaType == VideoMediaType.series || currentbilibiliVideo.category == VideoCategory.series) {
      if (list.isNotEmpty) return [];
      var result = await BiliBiliSite().playAlbumAllVideos(
        currentbilibiliVideo.aid!,
        currentbilibiliVideo.bvid!,
      );
      playitems.addAll(result);
      return playitems;
    } else if (currentMediaType == VideoMediaType.allVideos) {
      var newOld = list.isNotEmpty ? list.last.vid : "";
      if (newOld == oid.value && newOld.isNotEmpty) return [];
      oid.value = newOld;

      var result = await BiliBiliSite().getMediaList(
        currentbilibiliVideo.mid!,
        newOld,
        page: page,
        pageSize: pageSize,
      );
      playitems.addAll(result);
      return playitems;
    }
    return playitems;
  }

  @override
  void onInit() async {
    await loadData();
    await loadUserinfo();
    super.onInit();
  }

  Future<void> loadUserinfo() async {
    upUserInfo.value = await BiliBiliSite().getVidoeInfo(currentbilibiliVideo);
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }
}
