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
  var showSelectBox = false.obs;
  var isCheckAll = false.obs;
  var currentSelectItems = [].obs;
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
    var result = await BiliBiliSite().getRoomListDetail(bilibiliVideo.bvid!);
    for (var i = 0; i < result.length; i++) {
      playitems.add(PlayItems(liveMediaInfo: result[i], index: i, selected: false));
    }
    return playitems;
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
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
