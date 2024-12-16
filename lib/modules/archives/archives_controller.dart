import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/models/up_user_info.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/modules/archives/archives_grid_controller.dart';

class ArchivesController extends GetxController with GetSingleTickerProviderStateMixin {
  final List<SeriesLiveMedia> seriesLiveList;
  final UpUserInfo upUserInfo;
  final int sessionId;
  late TabController tabController;

  var index = 0.obs;

  ArchivesController({required this.seriesLiveList, required this.upUserInfo, required this.sessionId}) {
    index.value = seriesLiveList.indexWhere((element) => element.sessionId == sessionId);
    tabController = TabController(vsync: this, length: seriesLiveList.length, initialIndex: index.value);

    tabController.animation?.addListener(() {
      var currentIndex = (tabController.animation?.value ?? 0).round();
      if (index.value == currentIndex) {
        return;
      }
      index.value = currentIndex;
      var controller = Get.find<ArchivesGridController>(tag: seriesLiveList[index.value].sessionId.toString());
      if (controller.list.isEmpty) {
        controller.loadData();
      }
    });
  }

  @override
  void onInit() {
    for (var serie in seriesLiveList) {
      Get.put(ArchivesGridController(mid: upUserInfo.mid, sessionId: serie.sessionId!),
          tag: serie.sessionId.toString());
    }
    var controller = Get.find<ArchivesGridController>(tag: seriesLiveList[index.value].sessionId.toString());
    controller.loadData();
    super.onInit();
  }
}
