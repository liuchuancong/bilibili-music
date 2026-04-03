import 'dart:developer';
import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/plugins/utils.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';

class MusicCard extends StatelessWidget {
  const MusicCard({super.key, required this.bilibiliVideo, this.isVideo = false, this.showTrailing = false});

  final BilibiliVideoItem bilibiliVideo;
  final bool isVideo;
  final bool showTrailing;

  void onTap() async {
    VideoMediaType mediaType = VideoMediaType.masterpiece;
    if (bilibiliVideo.category == VideoCategory.series) {
      mediaType = VideoMediaType.series;
    } else if (bilibiliVideo.category == VideoCategory.customized) {
      mediaType = VideoMediaType.customized;
    } else if (bilibiliVideo.category == VideoCategory.published) {
      mediaType = VideoMediaType.masterpiece;
    } else {
      mediaType = VideoMediaType.allVideos;
    }
    AppNavigator.toLiveRoomDetailList(bilibiliVideo: bilibiliVideo, mediaType: mediaType);
  }

  ImageProvider? getRoomAvatar(String avatar) {
    try {
      return CachedNetworkImageProvider(
        avatar,
        errorListener: (err) {
          log("CachedNetworkImageProvider: Image failed to load!");
        },
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final AppSettingsService service = Get.find<AppSettingsService>();
      final currentVideo = service.currentPlaylist.isNotEmpty ? service.currentPlaylist[0] : null;

      // 🔥 只修复这里：正确判断当前是否正在播放
      final bool isPlaying = service.currentPlaylist.isNotEmpty &&
          currentVideo!.aid == bilibiliVideo.aid &&
          currentVideo.bvid == bilibiliVideo.bvid;

      final bool shouldShowPlayCount =
          bilibiliVideo.play != null && bilibiliVideo.play! > 0 && bilibiliVideo.category != VideoCategory.customized;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isPlaying
              ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
              : Theme.of(context).cardColor.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          hoverColor: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Hero(
                  tag: 'room_${bilibiliVideo.bvid}',
                  child: Container(
                    width: 96,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildCoverImage(),
                        if (isPlaying)
                          Container(
                            color: Colors.black54,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: SizedBox(
                                  width: 40,
                                  child: MiniMusicVisualizer(
                                    color: Colors.white,
                                    width: 5,
                                    height: 18,
                                    radius: 3,
                                    animate: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        bilibiliVideo.title ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isPlaying ? FontWeight.bold : FontWeight.w500,
                          color: isPlaying ? Theme.of(context).primaryColor : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildAvatar(context),
                          Expanded(
                            child: Text(
                              shouldShowPlayCount
                                  ? '${bilibiliVideo.author}  •  ${readableCount(bilibiliVideo.play.toString())} 播放'
                                  : '${bilibiliVideo.author}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isPlaying ? FontWeight.bold : FontWeight.w500,
                                color: Theme.of(context).hintColor.withValues(alpha: 0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showTrailing)
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.more_horiz_rounded,
                        size: 20,
                        color: Theme.of(context).hintColor.withValues(alpha: 0.6),
                      ),
                      onPressed: handleMore,
                      splashRadius: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAvatar(BuildContext context) {
    bool hasUpic = bilibiliVideo.upic != null && bilibiliVideo.upic!.isNotEmpty;
    bool isBiliSource =
        bilibiliVideo.category == VideoCategory.published || bilibiliVideo.category == VideoCategory.series;

    if (isBiliSource && hasUpic) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: CircleAvatar(
          radius: 9,
          backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.1),
          foregroundImage: getRoomAvatar(bilibiliVideo.upic!),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Icon(Icons.music_note_rounded, size: 14, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
    );
  }

  Widget _buildCoverImage() {
    if (bilibiliVideo.category == VideoCategory.customized || (bilibiliVideo.pic?.isEmpty ?? true)) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900, Colors.black],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(Icons.music_note_rounded, size: 40, color: Colors.white.withValues(alpha: 0.05)),
            ),
            const Icon(Icons.album_rounded, color: Colors.white38, size: 28),
          ],
        ),
      );
    }

    final url = bilibiliVideo.pic!.startsWith("http") ? bilibiliVideo.pic! : "http:${bilibiliVideo.pic}";

    return CachedNetworkImage(
      imageUrl: url,
      cacheManager: CustomCacheManager.instance,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Theme.of(context).focusColor.withValues(alpha: 0.1),
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
          ),
        ),
      ),
      errorWidget: (context, error, stackTrace) => Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.grey.shade800, Colors.grey.shade900])),
        child: const Icon(Icons.broken_image_rounded, color: Colors.white24, size: 20),
      ),
    );
  }

  Future<void> handleMore() async {
    var result = await Utils.showBottomSheet();
    final settings = Get.find<AppSettingsService>();
    if (result == '1') {
      settings.moveMusicToTop(bilibiliVideo);
    } else if (result == '2') {
      editMuiscAlbum();
    } else if (result == '3') {
      if (bilibiliVideo.id == settings.favoriteMusicPlaylistId) {
        SmartDialog.showToast("系统预设不允许删除");
      } else {
        settings.removeMusicAlbum(bilibiliVideo);
      }
    }
  }

  Future<void> editMuiscAlbum() async {
    final settings = Get.find<AppSettingsService>();
    Map<String, String?>? result = await Utils.showEditDialog(
      isEdit: true,
      title: bilibiliVideo.title!,
      author: bilibiliVideo.author!,
    );
    if (result != null) {
      settings.editMusicAlbum(
        BilibiliVideoItem(id: bilibiliVideo.id, title: result['title'], author: result['author']),
      );
    }
  }
}
