import 'package:get/get.dart';
import 'playlist_controller.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayListPage extends GetView<PlayListController> {
  const PlayListPage({super.key});

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
          Obx(() => IconButton(
                icon: Icon(
                  controller.settingsService.isExistMusicAlbum(controller.bilibiliVideo)
                      ? Icons.remove_circle_outline_rounded
                      : Icons.add_circle_outline_rounded,
                ),
                onPressed: () {
                  var list = controller.list.value.map((item) => item.liveMediaInfo as LiveMediaInfo).toList();
                  controller.settingsService.toggleCollectMusic(controller.bilibiliVideo, list);
                },
              )),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            // 操作按钮
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: const Icon(FontAwesomeIcons.headphonesSimple),
                      onPressed: () {
                        if (controller.list.isNotEmpty) {
                          var list = controller.list.value.map((item) => item.liveMediaInfo as LiveMediaInfo).toList();
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
                        if (controller.list.isNotEmpty) {
                          controller.showSelectBox.toggle();
                          if (controller.showSelectBox.value) {
                            controller.isCheckAll.value = false;
                          }
                        }
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
                            color: controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.play_circle_outline,
                                color:
                                    controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                var list =
                                    controller.list.value.map((item) => item.liveMediaInfo as LiveMediaInfo).toList();
                                controller.audioController.startPlayAtIndex(index, list);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_horiz,
                                color:
                                    controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                controller.settingsService.setCurrentMedia(mediaInfo);
                                AppNavigator.toLiveRoomDetail(mediaInfo: mediaInfo);
                              },
                            ),
                          ],
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
