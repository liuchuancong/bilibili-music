import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/up_user_info.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/common/base/base_controller.dart';

class AreaRoomsController extends BasePageController<LiveMediaInfo> {
  final UpUserInfo upUserInfo;

  AreaRoomsController({required this.upUserInfo});

  @override
  Future<List<LiveMediaInfo>> getData(int page, int pageSize) async {
    return await BiliBiliSite().getUpAllVideos(page, pageSize, upUserInfo.mid);
  }
}
