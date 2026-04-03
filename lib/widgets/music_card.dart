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
  const MusicCard({
    super.key,
    required this.bilibiliVideo,
    this.isVideo = false,
    this.showTrailing = false,
  });

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
    AppNavigator.toLiveRoomDetailList(
      bilibiliVideo: bilibiliVideo,
      mediaType: mediaType,
    );
  }

  ImageProvider? getRoomAvatar(String avatar) {
    try {
      return CachedNetworkImageProvider(avatar, errorListener: (err) {
        log("CachedNetworkImageProvider: Image failed to load!");
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppSettingsService service = Get.find<AppSettingsService>();
    final bool isPlaying = service.currentPlaylist.isNotEmpty &&
        service.getCurrentVideoInfo().aid == bilibiliVideo.aid &&
        service.getCurrentVideoInfo().bvid == bilibiliVideo.bvid;
    final bool shouldShowPlayCount =
        bilibiliVideo.play != null && bilibiliVideo.play! > 0 && bilibiliVideo.category != VideoCategory.customized;
    return Container(
      // 增加外边距，让卡片之间有呼吸感
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // 使用微弱的背景色和阴影，增加高级感
        color: isPlaying
            ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
            : Theme.of(context).cardColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        // 鼠标悬停时的反馈
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
                    borderRadius: BorderRadius.circular(10), // Rounder card corners
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
                                  width: 5, // Thick, bold bars
                                  height: 18, // Tall enough to see movement
                                  radius: 3, // IMPORTANT: Rounded bar ends
                                  animate: true, // Balanced spacing
                                ),
                              ),
                            ),
                          ),
                        )
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
                                : '${bilibiliVideo.author}', // Hide 0 plays/Customized play count
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

              // --- 3. 操作区：缩小按钮，增加精致感 ---
              if (showTrailing)
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(Icons.more_horiz_rounded, // 换成水平三个点，通常比垂直点更现代
                        size: 20,
                        color: Theme.of(context).hintColor.withValues(alpha: 0.6)),
                    onPressed: handleMore,
                    splashRadius: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    // Only show CircleAvatar if it's a Bilibili video/series with a valid upic
    bool hasUpic = bilibiliVideo.upic != null && bilibiliVideo.upic!.isNotEmpty;
    bool isBiliSource =
        bilibiliVideo.category == VideoCategory.published || bilibiliVideo.category == VideoCategory.series;

    if (isBiliSource && hasUpic) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 0.5), // Tiny border for definition
        ),
        child: CircleAvatar(
          radius: 9, // Slightly larger than before for better visibility
          backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.1),
          foregroundImage: getRoomAvatar(bilibiliVideo.upic!),
        ),
      );
    }

    // Fallback for "My Favorites" or Customized lists: Show a music icon instead of an empty circle
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Icon(Icons.music_note_rounded, size: 14, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
    );
  }

  Widget _buildCoverImage() {
    // 1. 处理自定义歌单/本地歌单的默认样式 (使用高级渐变)
    if (bilibiliVideo.category == VideoCategory.customized || (bilibiliVideo.pic?.isEmpty ?? true)) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.shade800,
              Colors.blueGrey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 背景微弱的水印图标
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(Icons.music_note_rounded, size: 40, color: Colors.white.withValues(alpha: 0.05)),
            ),
            // 中心精致图标
            const Icon(Icons.album_rounded, color: Colors.white38, size: 28),
          ],
        ),
      );
    }

    // 2. 正常网络图片逻辑
    final url = bilibiliVideo.pic!.startsWith("http") ? bilibiliVideo.pic! : "http:${bilibiliVideo.pic}";

    return CachedNetworkImage(
      imageUrl: url,
      cacheManager: CustomCacheManager.instance,
      fit: BoxFit.cover,
      // 图片加载时的占位状态 (同样使用渐变，避免白块闪烁)
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
      // 图片加载失败的样式 (与默认样式保持一致)
      errorWidget: (context, error, stackTrace) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.grey.shade900],
          ),
        ),
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
    Map<String, String?>? result =
        await Utils.showEditDialog(isEdit: true, title: bilibiliVideo.title!, author: bilibiliVideo.author!);
    if (result != null) {
      settings.editMusicAlbum(
        BilibiliVideoItem(
          id: bilibiliVideo.id,
          title: result['title'],
          author: result['author'],
        ),
      );
    }
  }
}
