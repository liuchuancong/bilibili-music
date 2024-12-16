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
      for (var i = 0; i < bilibiliVideo.medias.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: bilibiliVideo.medias[i], index: i, selected: false));
      }
      return playitems;
    }
    if (mediaType == VideoMediaTypes.masterpiece) {
      var result = await BiliBiliSite().getRoomListDetail(bilibiliVideo.bvid!);
      for (var i = 0; i < result.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
      }
      return playitems;
    } else if (mediaType == VideoMediaTypes.series || bilibiliVideo.status == VideoStatus.series) {
      var result = await BiliBiliSite().playAlbumAllVideos(bilibiliVideo.aid!, bilibiliVideo.bvid!);
      for (var i = 0; i < result.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
      }
      return playitems;
    }
    // var result = await BiliBiliSite().getVideoPlayUrl(bilibiliVideo.bvid!);
    // for (var i = 0; i < result.length; i++) {
    // VideoMediaTypes.series
    return playitems;
  }

  @override
  void onInit() {
    loadData();
    loadUserinfo();
    super.onInit();
  }

  loadUserinfo() async {
    upUserInfo.value = await BiliBiliSite().getVidoeInfo(bilibiliVideo);
  }

  handleCheckAll() {
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

  handleToggleItem(int index) {
    list[index].selected = list[index].selected ? false : true;
    list.value = List.from(list);
  }
}
