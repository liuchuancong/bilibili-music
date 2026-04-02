import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/bili_up_info.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/common/base/base_controller.dart';

class AreaRoomsController extends BasePageController<VideoMediaInfo> {
  final BiliUpInfo upUserInfo;

  AreaRoomsController({required this.upUserInfo});

  @override
  Future<List<VideoMediaInfo>> getData(int page, int pageSize) async {
    return await BiliBiliSite().getUpAllVideos(page, pageSize, upUserInfo.mid);
  }
}
