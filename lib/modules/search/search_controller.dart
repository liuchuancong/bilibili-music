import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';

class SearchMusicController extends BasePageController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var index = 0.obs;
  TextEditingController searchController = TextEditingController();

  var saerchType = "video".obs;

  var order = 'zh'.obs;

  final List<String> orderList = ["zh", "click", "pubdate", "dm", "stow"];

  final List<String> tabList = ["综合排序", "最多播放", "最新发布", "最多弹幕", "最多收藏"];

  SearchMusicController() {
    tabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    tabController.addListener(() {
      index.value = tabController.index;
      doSearch();
    });
  }

  @override
  Future<List> getData(int page, int pageSize) async {
    if (searchController.text.isEmpty) {
      return [];
    }
    var result = await BiliBiliSite().getSearchVideoLists(searchController.text, orderList[index.value], page: page);
    return result.items;
  }

  void doSearch() {
    if (searchController.text.isEmpty) {
      return;
    }
    BiliBiliSite()
        .getSearchVideoLists(searchController.text, orderList[index.value], page: 1)
        .then((VideoSaerchResult value) {
      list.value = value.items;
      canLoadMore.value = value.hasMore;
    });
  }
}
