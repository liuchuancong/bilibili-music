import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/utils/event_bus.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/up_user_info.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class PlayListController extends BasePageController<PlayItems> {
  final BilibiliVideo bilibiliVideo;
  final VideoMediaTypes mediaType;
  PlayListController({required this.bilibiliVideo, required this.mediaType})
      : currentbilibiliVideo = bilibiliVideo,
        currentMediaType = mediaType;
  SettingsService settingsService = Get.find<SettingsService>();
  StreamSubscription<dynamic>? subscription;
  var showSelectBox = false.obs;
  var isCheckAll = false.obs;
  var currentSelectItems = [].obs;
  var oid = "".obs;
  var upUserInfo = UpUserInfo(
    name: "",
    desc: "",
    face: "",
    mid: "",
    like: 0,
    follower: 0,
    loaded: false,
  ).obs;
  BilibiliVideo currentbilibiliVideo;
  VideoMediaTypes currentMediaType;
  final AudioController audioController = Get.find<AudioController>();
  @override
  Future<List<PlayItems>> getData(int page, int pageSize) async {
    List<PlayItems> playitems = [];
    if (currentbilibiliVideo.status == VideoStatus.customized) {
      if (list.isNotEmpty) {
        return [];
      }
      for (var i = 0; i < currentbilibiliVideo.medias.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: currentbilibiliVideo.medias[i], index: i, selected: false));
      }
      return playitems;
    } else if (currentMediaType == VideoMediaTypes.masterpiece) {
      if (list.isNotEmpty) {
        return [];
      }
      var result = await BiliBiliSite().getRoomListDetail(currentbilibiliVideo.bvid!);
      for (var i = 0; i < result.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
      }
      return playitems;
    } else if (currentMediaType == VideoMediaTypes.series || currentbilibiliVideo.status == VideoStatus.series) {
      if (list.isNotEmpty) {
        return [];
      }
      var result = await BiliBiliSite().playAlbumAllVideos(currentbilibiliVideo.aid!, currentbilibiliVideo.bvid!);
      for (var i = 0; i < result.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
      }
      return playitems;
    } else if (currentMediaType == VideoMediaTypes.allVideos) {
      var newOld = list.isNotEmpty ? list.last.liveMediaInfo.vid : "";
      if (newOld == oid.value && newOld.isNotEmpty) {
        return [];
      } else {
        oid.value = newOld;
      }
      var result = await BiliBiliSite().getMediaList(currentbilibiliVideo.mid!, newOld, page: page, pageSize: pageSize);
      for (var i = 0; i < result.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
      }

      return playitems;
    }
    return playitems;
  }

  @override
  void onInit() {
    subscription = EventBus.instance.listen('toLiveRoomDetailList', (data) async {
      SmartDialog.showLoading(msg: '加载中...');
      var bilibiliVideo = data[0] as BilibiliVideo;
      var videoMediaTypes = data[1] as VideoMediaTypes;
      currentbilibiliVideo = bilibiliVideo;
      currentMediaType = videoMediaTypes;
      list.clear();
      await loadData();
      await loadUserinfo();
      SmartDialog.dismiss();
    });
    super.onInit();
  }

  Future<void> loadUserinfo() async {
    upUserInfo.value = await BiliBiliSite().getVidoeInfo(currentbilibiliVideo);
  }

  void handleCheckAll() {
    isCheckAll.toggle();
    if (isCheckAll.value) {
      for (var item in list.value) {
        item.selected = true;
      }
    } else {
      for (var item in list.value) {
        item.selected = false;
      }
    }
    list.value = List.from(list);
  }

  void handleToggleItem(int index) {
    list[index].selected = list[index].selected ? false : true;
    list.value = List.from(list);
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }
}
