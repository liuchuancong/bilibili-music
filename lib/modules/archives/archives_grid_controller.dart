import 'dart:async';
import 'package:get/get.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/common/base/base_controller.dart';
import 'package:bilibilimusic/modules/archives/archives_controller.dart';

class ArchivesGridController extends BasePageController<VideoMediaInfo> {
  final String mid;
  final int sessionId;
  ArchivesController archivesController = Get.find<ArchivesController>();
  ArchivesGridController({
    required this.mid,
    required this.sessionId,
  });

  @override
  Future<List<VideoMediaInfo>> getData(int page, int pageSize) async {
    return await BiliBiliSite().getArchivesVideos(
      page,
      pageSize,
      mid,
      sessionId,
      archivesController.upUserInfo.face,
      archivesController.upUserInfo.name,
      archivesController.upUserInfo.like!,
    );
  }
}
