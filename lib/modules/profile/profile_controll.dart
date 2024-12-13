import 'package:get/get.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/up_user_info.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/common/base/base_controller.dart';

class ProfileController extends BasePageController {
  final UpUserInfo upUserInfo;
  ProfileController({required this.upUserInfo});
  SettingsService settingsService = Get.find<SettingsService>();

  final followed = false.obs;

  var masterpiece = SeriesLiveMedia(
    name: '代表作',
    total: 0,
    liveMediaInfoList: [],
  ).obs;

  var allVideos = SeriesLiveMedia(
    name: 'TA的视频',
    total: 0,
    liveMediaInfoList: [],
  ).obs;

  var seasonsSeries = [].obs;
  @override
  void onInit() {
    super.onInit();
    followed.value = settingsService.isFollowed(upUserInfo.mid);
    fetchMasterpiece();
    fetchAllVideos();
    fetchSeasonsSeries();
  }

  void toggleFollow() {
    settingsService.toggleFollow(upUserInfo);
    followed.toggle();
  }

  void fetchSeasonsSeries() async {
    seasonsSeries.value = await BiliBiliSite().getSeasonsSeries(upUserInfo.mid);
  }

  void fetchAllVideos() async {
    allVideos.value = await BiliBiliSite().getAllVideos(upUserInfo.mid);
  }

  void fetchMasterpiece() async {
    masterpiece.value = await BiliBiliSite().getMasterpiece(upUserInfo.mid);
  }
}
