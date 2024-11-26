import 'package:get/get.dart';
import 'playlist_controller.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                        color:
                            controller.bilibiliVideo.status == VideoStatus.customized ? Colors.black : Colors.black45),
                  ),
                ),
                onTap: () {
                  if (controller.bilibiliVideo.status == VideoStatus.customized) {
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

  void showMusicAlubmSelectorDialog() {
    final SettingsService settings = Get.find<SettingsService>();
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
                  children: settings.musicAlbum
                      .where((el) => el.status == VideoStatus.customized)
                      .where((el) => el.id != controller.bilibiliVideo.id)
                      .map(
                        (BilibiliVideo item) => TextButton(
                          onPressed: () {
                            List<LiveMediaInfo> list = controller.list.value
                                .where((el) => el.selected)
                                .map((item) => item.liveMediaInfo as LiveMediaInfo)
                                .toList();
                            settings.addMusicToAlbum(item.id, list);
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

  handleMusicAlbumSelector() async {
    String? result = await showBottomSheet();
    if (result == '1') {
      showMusicAlubmSelectorDialog();
    } else if (result == '2') {
      // 删除
      List<LiveMediaInfo> list =
          controller.list.value.where((el) => el.selected).map((item) => item.liveMediaInfo as LiveMediaInfo).toList();
      List<LiveMediaInfo> sourcelist =
          controller.settingsService.deleteMusicFromAlbum(controller.bilibiliVideo.id, list);
      List<PlayItems> playitems = [];
      for (var i = 0; i < sourcelist.length; i++) {
        playitems.add(PlayItems(liveMediaInfo: sourcelist[i], index: i, selected: false));
      }
      controller.list.value = playitems;
      SmartDialog.showToast('删除成功');
    }
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
                if (controller.bilibiliVideo.id == controller.settingsService.favoriteId) {
                  SmartDialog.showToast('系统预设歌单不可修改');
                } else {
                  var list = controller.list.value.map((item) => item.liveMediaInfo as LiveMediaInfo).toList();
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
            // 操作按钮
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: const Icon(FontAwesomeIcons.headphonesSimple),
                          onPressed: () {
                            if (controller.list.isNotEmpty) {
                              var list =
                                  controller.list.value.map((item) => item.liveMediaInfo as LiveMediaInfo).toList();
                              controller.settingsService.setCurreentMusicList(list);
                            }
                          }),
                      if (controller.showSelectBox.value)
                        Obx(() => IconButton(
                            icon: controller.isCheckAll.value
                                ? const Icon(FontAwesomeIcons.squareCheck)
                                : const Icon(FontAwesomeIcons.square),
                            onPressed: () {
                              if (controller.list.isNotEmpty) {
                                controller.handleCheckAll();
                              }
                            })),
                      IconButton(
                          icon: const Icon(Icons.select_all_outlined),
                          onPressed: () {
                            if (controller.list.isNotEmpty) {
                              controller.showSelectBox.toggle();
                              if (controller.showSelectBox.value) {
                                controller.isCheckAll.value = false;
                              }
                            }
                          }),
                      IconButton(
                          icon: const Icon(FontAwesomeIcons.penToSquare),
                          onPressed: () {
                            if (controller.showSelectBox.value) {
                              List<LiveMediaInfo> list = controller.list.value
                                  .where((el) => el.selected)
                                  .map((item) => item.liveMediaInfo as LiveMediaInfo)
                                  .toList();
                              if (list.isNotEmpty) {
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
            // 分割线
            const Divider(height: 1, color: Color.fromARGB(255, 196, 191, 191)),
            Expanded(
              child: ListView.builder(
                itemCount: controller.list.length,
                itemBuilder: (context, index) {
                  PlayItems playItems = controller.list[index];
                  LiveMediaInfo mediaInfo = playItems.liveMediaInfo;
                  return Obx(
                    () => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      color:
                          controller.settingsService.isCurrentMediia(mediaInfo) ? Get.theme.colorScheme.primary : null,
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          var list = controller.list.value.map((item) => item.liveMediaInfo as LiveMediaInfo).toList();
                          controller.audioController.startPlayAtIndex(index, list);
                        },
                        child: ListTile(
                          leading: controller.showSelectBox.value
                              ? Obx(() => IconButton(
                                  onPressed: () {
                                    controller.handleToggleItem(index);
                                  },
                                  icon: Icon(
                                    playItems.selected ? FontAwesomeIcons.squareCheck : FontAwesomeIcons.square,
                                    color: controller.settingsService.isCurrentMediia(mediaInfo)
                                        ? Colors.white
                                        : Colors.black,
                                  )))
                              : null,
                          title: Text(
                            mediaInfo.part,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}
