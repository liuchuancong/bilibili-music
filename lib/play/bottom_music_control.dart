import 'package:get/get.dart';
import 'package:marquee_list/marquee_list.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class BottomMusicControl extends GetWidget<AudioController> {
  const BottomMusicControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12, width: 1)),
        color: Color.fromARGB(255, 203, 205, 214),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                              child: CachedNetworkImage(imageUrl: controller.playlist[controller.currentIndex].face),
                            ),
                          )
                        : const Icon(Icons.music_note),
                    title: controller.playlist.isNotEmpty
                        ? MarqueeList(
                            key: ValueKey(controller.playlist[controller.currentIndex].cid),
                            scrollDirection: Axis.horizontal,
                            scrollDuration: const Duration(seconds: 2),
                            children: [
                              Text(
                                controller.playlist[controller.currentIndex].part,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const Text('暂无歌曲'),
                    subtitle: controller.playlist.isNotEmpty
                        ? Text(controller.playlist[controller.currentIndex].name)
                        : const Text('请选择歌单'),
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
                    ),
                    onPressed: controller.previous,
                  ),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                      onPressed: () {
                        if (controller.audioPlayer.playing) {
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
                    ),
                    onPressed: controller.next,
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
                total: controller.currentMusicDuration.value,
                onSeek: (duration) {
                  controller.seek(duration);
                },
              )),
        ],
      ),
    );
  }
}
