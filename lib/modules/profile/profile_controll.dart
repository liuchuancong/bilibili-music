import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/bili_up_info.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/common/base/base_controller.dart';

class ProfileController extends BasePageController {
  final BiliUpInfo upUserInfo;
  ProfileController({required this.upUserInfo});
  AppSettingsService settingsService = Get.find<AppSettingsService>();
  final followed = false.obs;

  final innerController = ScrollController();

  final masterpieceController = ScrollController();

  final allVideosController = ScrollController();

  final seasonsSeriesController = ScrollController();
  var masterpiece = VideoMediaSeries(
    name: '代表作',
    total: 0,
    mediaList: [],
  ).obs;

  var allVideos = VideoMediaSeries(
    name: 'TA的视频',
    total: 0,
    mediaList: [],
  ).obs;

  var seasonsSeries = <VideoMediaSeries>[].obs;
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
