import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/up_user_info.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class PlayListController extends BasePageController<PlayItems> {
  final BilibiliVideo bilibiliVideo;
  final VideoMediaTypes mediaType;
  PlayListController({required this.bilibiliVideo, required this.mediaType});
  SettingsService settingsService = Get.find<SettingsService>();
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

  final AudioController audioController = Get.find<AudioController>();
  @override
  Future<List<PlayItems>> getData(int page, int pageSize) async {
    List<PlayItems> playitems = [];
    if (bilibiliVideo.status == VideoStatus.customized) {
      if (list.isNotEmpty) {
        return [];
      }
      for (var i = 0; i < bilibiliVideo.medias.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: bilibiliVideo.medias[i], index: i, selected: false));
      }
      return playitems;
    } else if (mediaType == VideoMediaTypes.masterpiece) {
      if (list.isNotEmpty) {
        return [];
      }
      var result = await BiliBiliSite().getRoomListDetail(bilibiliVideo.bvid!);
      for (var i = 0; i < result.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
      }
      return playitems;
    } else if (mediaType == VideoMediaTypes.series || bilibiliVideo.status == VideoStatus.series) {
      if (list.isNotEmpty) {
        return [];
      }
      var result = await BiliBiliSite().playAlbumAllVideos(bilibiliVideo.aid!, bilibiliVideo.bvid!);
      for (var i = 0; i < result.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
      }
      return playitems;
    } else if (mediaType == VideoMediaTypes.allVideos) {
      var newOld = list.isNotEmpty ? list.last.liveMediaInfo.vid : "";
      if (newOld == oid.value && newOld.isNotEmpty) {
        return [];
      } else {
        oid.value = newOld;
      }
      var result = await BiliBiliSite().getMediaList(bilibiliVideo.mid!, newOld, page: page, pageSize: pageSize);
      for (var i = 0; i < result.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
      }

      return playitems;
    }
    return playitems;
  }

  @override
  void onInit() {
    loadData();
    loadUserinfo();
    super.onInit();
  }

  Future<void> loadUserinfo() async {
    upUserInfo.value = await BiliBiliSite().getVidoeInfo(bilibiliVideo);
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
}
