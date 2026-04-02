import 'dart:developer';
import 'package:get/get.dart';
import 'playlist_controller.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class PlayListPage extends GetView<PlayListController> {
  const PlayListPage({super.key});

  Future<String?> showBottomSheet() async {
    var result = await Get.bottomSheet(
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Center(child: Text('添加到歌单')),
                onTap: () {
                  Navigator.of(Get.context!).pop('1');
                },
              ),
              ListTile(
                title: Center(
                  child: Text(
                    '删除',
                    style: TextStyle(
                        color: controller.bilibiliVideo.category == VideoCategory.customized
                            ? Colors.black
                            : Colors.black45),
                  ),
                ),
                onTap: () {
                  if (controller.bilibiliVideo.category == VideoCategory.customized) {
                    Navigator.of(Get.context!).pop('2');
                  }
                },
              ),
              ListTile(
                title: const Center(child: Text('取消')),
                onTap: () {
                  Navigator.of(Get.context!).pop('3');
                },
              ),
            ],
          ),
        ),
      ),
      isDismissible: true,
    );
    return result;
  }

  void showMusicAlbumSelectorDialog() {
    final AppSettingsService settings = Get.find<AppSettingsService>();
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('添加到歌单'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  children: settings.musicPlaylists
                      .where((el) => el.category == VideoCategory.customized)
                      .where((el) => el.id != controller.bilibiliVideo.id)
                      .map(
                        (BilibiliVideoItem item) => TextButton(
                          onPressed: () {
                            List<int> selectedIndexes = controller.multiSelectController.getSelectedItems();
                            List<VideoMediaInfo> selectedList =
                                selectedIndexes.map((idx) => controller.list[idx]).toList();

                            settings.addMusicToAlbum(item.id, selectedList);
                            Navigator.of(Get.context!).pop();
                            SmartDialog.showToast('添加成功');
                          },
                          child: Text(item.title!),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        });
  }

  Future<void> handleMusicAlbumSelector() async {
    String? result = await showBottomSheet();
    if (result == '1') {
      showMusicAlbumSelectorDialog();
    } else if (result == '2') {
      List<int> selectedIndexes = controller.multiSelectController.getSelectedItems();
      List<VideoMediaInfo> deleteList = selectedIndexes.map((idx) => controller.list[idx]).toList();

      List<VideoMediaInfo> sourcelist =
          controller.settingsService.deleteMusicFromAlbum(controller.bilibiliVideo.id, deleteList);
      controller.list.value = sourcelist;
      controller.multiSelectController.deselectAll();

      SmartDialog.showToast('删除成功');
      controller.refreshData();

      if (controller.bilibiliVideo.id == controller.settingsService.favoriteMusicPlaylistId) {
        final AudioController audioController = Get.find<AudioController>();
        audioController.isFavorite.value = controller.settingsService.isInFavoriteMusic(
            controller.settingsService.currentPlaylist[controller.settingsService.currentPlayIndex.value]);
      }
    }
  }

  String removeNumberPrefix(String text) {
    final regex = RegExp(r'^\s*\d+[.\s]*');
    return text.replaceFirst(RegExp(r'^\d+[.\s]*'), '').replaceFirst(regex, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '播放列表',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Obx(
            () => IconButton(
              icon: Icon(
                controller.settingsService.isExistMusicAlbum(controller.bilibiliVideo)
                    ? Icons.remove_circle_outline_rounded
                    : Icons.add_circle_outline_rounded,
              ),
              onPressed: () {
                if (controller.bilibiliVideo.id == controller.settingsService.favoriteMusicPlaylistId) {
                  SmartDialog.showToast('系统预设歌单不可修改');
                } else {
                  var list = controller.list.value.toList();
                  log(controller.bilibiliVideo.toJson().toString());
                  controller.settingsService.toggleCollectMusic(controller.bilibiliVideo, list);
                }
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            if (controller.upUserInfo.value.loaded)
              Obx(
                () => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(controller.upUserInfo.value.face),
                  ),
                  title: Text(
                    controller.upUserInfo.value.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    controller.upUserInfo.value.desc,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                  trailing: TextButton(
                      onPressed: () {
                        controller.settingsService.toggleFollow(controller.upUserInfo.value);
                      },
                      child: controller.settingsService.isFollowed(controller.upUserInfo.value.mid)
                          ? const Text('已关注')
                          : const Text('关注')),
                  onTap: () {
                    Get.toNamed(RoutePath.kProfile, arguments: controller.upUserInfo.value);
                  },
                ),
              ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: const FaIcon(FontAwesomeIcons.headphones),
                          onPressed: () {
                            if (controller.list.isNotEmpty) {
                              var list = controller.list.value.toList();
                              controller.settingsService.setCurrentMusicList(list);
                            }
                          }),
                      if (controller.showSelectBox.value)
                        IconButton(
                            icon: const FaIcon(FontAwesomeIcons.squareCheck),
                            onPressed: () {
                              controller.multiSelectController.selectAll();
                            }),
                      IconButton(
                          icon: const Icon(Icons.select_all_outlined),
                          onPressed: () {
                            if (controller.list.isNotEmpty) {
                              controller.showSelectBox.toggle();
                              controller.multiSelectController.deselectAll();
                            }
                          }),
                      IconButton(
                          icon: const FaIcon(FontAwesomeIcons.penToSquare),
                          onPressed: () {
                            if (controller.showSelectBox.value) {
                              if (controller.multiSelectController.getSelectedItems().isNotEmpty) {
                                handleMusicAlbumSelector();
                              } else {
                                SmartDialog.showToast('请选择歌曲');
                              }
                            }
                          }),
                    ],
                  ),
                  IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () {
                        controller.refreshData();
                      }),
                ],
              ),
            ),
            const Divider(height: 1, color: Color.fromARGB(255, 196, 191, 191)),
            Expanded(
              child: EasyRefresh(
                controller: controller.easyRefreshController,
                onRefresh: controller.refreshData,
                onLoad: controller.loadData,
                child: controller.showSelectBox.value
                    ? MultiSelectCheckList(
                        controller: controller.multiSelectController,
                        textStyles: const MultiSelectTextStyles(
                          selectedTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        itemsDecoration: MultiSelectDecorations(
                          selectedDecoration: BoxDecoration(
                            color: Colors.indigo.withAlpha(200),
                          ),
                        ),
                        listViewSettings: ListViewSettings(
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const Divider(height: 0),
                        ),
                        items: List.generate(
                          controller.list.length,
                          (index) {
                            final mediaInfo = controller.list[index];
                            return CheckListCard(
                              value: index,
                              title: Text(
                                '${index + 1}. ${removeNumberPrefix(mediaInfo.part)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: controller.settingsService.isCurrentMedia(mediaInfo)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selectedColor: Colors.white,
                              checkColor: Colors.indigo,
                              checkBoxBorderSide: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          },
                        ),
                        onChange: (allSelectedItems, selectedItem) {},
                      )
                    : ListView.builder(
                        itemCount: controller.list.length,
                        itemBuilder: (context, index) {
                          VideoMediaInfo mediaInfo = controller.list[index];
                          return Obx(
                            () => Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              color: controller.settingsService.isCurrentMedia(mediaInfo)
                                  ? Get.theme.colorScheme.primary
                                  : null,
                              elevation: 4,
                              child: InkWell(
                                onTap: () {
                                  var list = controller.list.value.toList();
                                  controller.audioController.startPlayAtIndex(index, list);
                                },
                                child: ListTile(
                                  title: Text(
                                    '${index + 1}. ${removeNumberPrefix(mediaInfo.part)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: controller.settingsService.isCurrentMedia(mediaInfo)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}

class SimpleVideoCard extends StatelessWidget {
  final VideoMediaInfo mediaInfo;
  final Function() onTap;

  const SimpleVideoCard({
    super.key,
    required this.mediaInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    mediaInfo.pic.startsWith("http") ? mediaInfo.pic : "http:${mediaInfo.pic}",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ListTile(
                title: SizedBox(
                  height: 50,
                  child: Text(
                    mediaInfo.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                trailing: Text(
                  formatDuration(mediaInfo.duration),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
