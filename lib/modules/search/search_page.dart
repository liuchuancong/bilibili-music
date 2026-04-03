import 'package:get/get.dart';
import 'search_controller.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/widgets/music_card.dart';
import 'package:bilibilimusic/widgets/empty_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPage extends GetView<SearchMusicController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: controller.searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "搜索",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            prefixIcon: IconButton(
              onPressed: () {
                Navigator.of(Get.context!).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            suffixIcon: IconButton(
              onPressed: controller.doSearch,
              icon: const Icon(Icons.search),
            ),
          ),
          onSubmitted: (e) {
            controller.doSearch();
          },
        ),
        bottom: TabBar(
          controller: controller.tabController,
          padding: EdgeInsets.zero,
          tabAlignment: TabAlignment.center,
          tabs: controller.tabList.map((e) => Tab(text: e)).toList(),
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        final width = constraint.maxWidth;
        final crossAxisCount = width > 1280 ? 4 : (width > 960 ? 3 : (width > 640 ? 2 : 1));
        return Obx(() => EasyRefresh(
              controller: controller.easyRefreshController,
              onRefresh: controller.refreshData,
              onLoad: controller.loadData,
              child: controller.list.isNotEmpty
                  ? MasonryGridView.count(
                      padding: const EdgeInsets.all(8),
                      physics: const BouncingScrollPhysics(),
                      controller: controller.scrollController,
                      crossAxisCount: crossAxisCount,
                      itemCount: controller.list.length,
                      itemBuilder: (context, index) {
                        return MusicCard(bilibiliVideo: controller.list[index]);
                      },
                    )
                  : const EmptyView(
                      icon: Icons.search,
                      title: "暂无搜索结果",
                      subtitle: "请尝试更换关键词或稍后再试",
                    ),
            ));
      }),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}

class CountChip extends StatelessWidget {
  const CountChip({
    super.key,
    required this.icon,
    required this.count,
    this.color = Colors.black,
  });

  final IconData icon;
  final String count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: color.withValues(alpha: 0.8),
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 14,
            ),
            Text(
              count.isEmpty ? '0' : count,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
