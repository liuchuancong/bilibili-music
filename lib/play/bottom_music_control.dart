import 'package:get/get.dart';
import 'package:marquee_list/marquee_list.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class BottomMusicControl extends GetWidget<AudioController> {
  const BottomMusicControl({super.key});
  TextStyle _bodyText2Style(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(height: 2, fontSize: 16, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          border: Border(top: BorderSide(color: Colors.black26, width: 1)),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
            Colors.black,
            Colors.black87,
            Colors.black54,
            Colors.black87,
            Colors.black,
          ]),
        ),
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ListTile(
                      splashColor: Colors.transparent,
                      tileColor: Colors.transparent, // 防止整个 ListTile 被着色
                      contentPadding: EdgeInsets.zero, // 防止默认内边距影响视觉效果
                      visualDensity: VisualDensity.compact, // 紧凑模式，更小的 padding
                      dense: true,
                      enableFeedback: false,
                      leading: controller.playlist.isNotEmpty
                          ? CircleAvatar(
                              child: ClipOval(
                                child: Obx(() => controller.currentMusicInfo.value['cover']!.isNotEmpty
                                    ? CachedNetworkImage(imageUrl: controller.currentMusicInfo.value['cover']!)
                                    : CachedNetworkImage(imageUrl: controller.playlist[controller.currentIndex].face)),
                              ),
                            )
                          : const Icon(
                              Icons.music_note,
                              color: Colors.white,
                            ),
                      title: controller.playlist.isNotEmpty
                          ? MarqueeList(
                              key: ValueKey(controller.playlist[controller.currentIndex].cid),
                              scrollDirection: Axis.horizontal,
                              scrollDuration: const Duration(seconds: 2),
                              children: [
                                Text(
                                  controller.playlist[controller.currentIndex].part,
                                  style:
                                      const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            )
                          : const Text('暂无歌曲', style: TextStyle(color: Colors.white)),
                      subtitle: controller.playlist.isNotEmpty
                          ? Obx(() => Text(
                              controller.currentMusicInfo.value['author']!.isNotEmpty
                                  ? controller.currentMusicInfo.value['author']!
                                  : controller.currentMediaInfo.name,
                              style: const TextStyle(color: Colors.white)))
                          : const Text('请选择歌单', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        if (controller.playlist.isNotEmpty) {
                          Get.toNamed(RoutePath.kmusicPage);
                        }
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: controller.previous,
                    ),
                    Obx(
                      () => IconButton(
                        icon: Icon(
                          controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                          size: 32,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: controller.next,
                    ),
                    Obx(
                      () => IconButton(
                        icon: Icon(
                          controller.isFavorite.value ? Icons.favorite : Icons.favorite_border_rounded,
                          size: 32,
                          color: controller.isFavorite.value ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          controller.toggleFavorite();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Obx(() => ProgressBar(
                  progress: controller.currentMusicPosition.value,
                  barHeight: 5,
                  thumbRadius: 4,
                  thumbGlowRadius: 8,
                  baseBarColor: Colors.white.withValues(alpha: 0.5),
                  progressBarColor: Colors.red[700],
                  bufferedBarColor: Colors.red[300],
                  thumbColor: Colors.white,
                  thumbGlowColor: Colors.white,
                  timeLabelTextStyle: _bodyText2Style(context),
                  total: controller.currentMusicDuration.value,
                  onSeek: (duration) {
                    controller.seek(duration);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
