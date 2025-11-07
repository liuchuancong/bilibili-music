import 'dart:io';
import 'package:snacknload/snacknload.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/widgets/sf_icon.dart';
import 'package:bilibilimusic/utils/theme_utils.dart';
import 'package:bilibilimusic/utils/common_utils.dart';
import 'package:bilibilimusic/widgets/slider_custom.dart';
import 'package:bilibilimusic/services/player_provider.dart';

class MiniPlayer extends ConsumerStatefulWidget {
  final double containerWidth;
  final bool isMobile;

  const MiniPlayer({
    super.key,
    this.containerWidth = double.infinity,
    this.isMobile = false,
  });

  // 2. 状态类改为 ConsumerState
  @override
  ConsumerState<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends ConsumerState<MiniPlayer> {
  double _tempSliderValue = -1; // -1 表示没在拖动

  String getDisplayTitle(Song? currentSong) {
    if (currentSong == null) return '未播放';
    final title = currentSong.title.trim();
    if (currentSong.artist == null) return title;
    final artist = currentSong.artist?.trim() ?? '';
    if (title.isNotEmpty && artist.isNotEmpty) {
      return '$title - $artist';
    } else if (title.isNotEmpty) {
      return title;
    } else if (artist.isNotEmpty) {
      return artist;
    } else {
      return '未播放';
    }
  }

  IconData getPlayModeIcon(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.single:
        return Icons.repeat_one_rounded;
      case PlayMode.sequence:
        return Icons.repeat;
      case PlayMode.shuffle:
        return Icons.shuffle_rounded;
    }
  }

  void setPlayMode(PlayMode currentMode) {
    final playerNotifier = ref.watch(playerNotifierProvider.notifier);
    const allModes = PlayMode.values;
    final currentIndex = allModes.indexOf(currentMode);
    final nextIndex = (currentIndex + 1) % allModes.length;
    final nextMode = allModes[nextIndex];

    playerNotifier.setPlayMode(nextMode);

    const modeMap = {
      PlayMode.single: '单曲循环',
      PlayMode.sequence: '顺序播放',
      PlayMode.shuffle: '随机播放',
    };

    SnackNLoad.showToast('${modeMap[nextMode]} 模式', maskType: MaskType.none, position: SnackNLoadPosition.center);
  }

  @override
  Widget build(BuildContext context) {
    final playerNotifier = ref.watch(playerNotifierProvider.notifier);
    final currentSong = ref.watch(playerNotifierProvider.select((s) => s.currentSong));
    final position = ref.watch(playerNotifierProvider.select((s) => s.position));
    final duration = ref.watch(playerNotifierProvider.select((s) => s.duration));
    final isPlaying = ref.watch(playerNotifierProvider.select((s) => s.isPlaying));
    final isLoading = ref.watch(playerNotifierProvider.select((s) => s.isLoading));
    final playMode = ref.watch(playerNotifierProvider.select((s) => s.playMode));
    final volume = ref.watch(playerNotifierProvider.select((s) => s.volume));

    final activeColor = ThemeUtils.select(
      context,
      light: Colors.black87,
      dark: Colors.white,
    );
    final inactiveColor = ThemeUtils.select(
      context,
      light: Colors.black26,
      dark: Colors.white30,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: !widget.isMobile ? 10.0 : 5.0,
        horizontal: !widget.isMobile ? 10.0 : 5.0,
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      SnackNLoad.showToast('操作失败: ', maskType: MaskType.none);
                      if (currentSong == null) return;
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return Container();
                            // return widget.isMobile
                            //     ? const MobileNowPlayingScreen()
                            //     : const ImprovedNowPlayingScreen(); // 假设该组件已存在
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            );
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: Offset.zero,
                              ).animate(curvedAnimation),
                              child: FadeTransition(
                                opacity: curvedAnimation,
                                child: child,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: currentSong?.albumArtPath != null
                            ? DecorationImage(
                                image: FileImage(File(currentSong!.albumArtPath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: currentSong?.albumArtPath == null ? const Icon(Icons.music_note_rounded, size: 24) : null,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                // // 歌曲信息（标题、歌手、进度条）
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextScroll(getDisplayTitle(currentSong),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                  icon: const Icon(Icons.favorite_border_rounded),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                  icon: const Icon(Icons.more),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 上一首
                    IconButton(
                        color: activeColor,
                        icon: const Icon(Icons.skip_previous_rounded, size: 40),
                        // 顺序模式下无 previous 时禁用
                        onPressed: () {
                          playerNotifier.previous();
                        }),
                    // 播放/暂停（带加载指示器）
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                            color: activeColor,
                            icon: Icon(
                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 40,
                            ),
                            onPressed: () {
                              if (currentSong != null) {
                                playerNotifier.togglePlay(); // 切换播放状态
                              }
                            }),
                        // 加载中显示圆形进度条
                        if (isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    // 下一首
                    IconButton(
                      color: activeColor,
                      icon: const Icon(Icons.skip_next_rounded, size: 40),
                      onPressed: () {
                        playerNotifier.next();
                      },
                    ),
                    IconButton(
                      iconSize: 28,
                      icon: Icon(
                        getPlayModeIcon(playMode),
                        color: activeColor,
                      ),
                      onPressed: () {
                        setPlayMode(playMode);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        CommonUtils.formatDuration(position),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          // 计算进度条值（拖动时用临时值，否则用真实进度）
                          final sliderValue = (_tempSliderValue >= 0
                                  ? _tempSliderValue
                                  : (duration.inMilliseconds > 0
                                      ? position.inMilliseconds / duration.inMilliseconds
                                      : 0.0))
                              .clamp(0.0, 1.0);

                          return AnimatedTrackHeightSlider(
                            trackHeight: 4,
                            value: sliderValue,
                            min: 0.0,
                            max: 1.0,
                            onChanged: currentSong != null
                                ? (value) {
                                    setState(() => _tempSliderValue = value); // 拖动时暂存值
                                  }
                                : null,
                            onChangeEnd: currentSong != null
                                ? (value) async {
                                    // 拖动结束后更新播放进度
                                    final newPosition = Duration(
                                      milliseconds: (value * duration.inMilliseconds).round(),
                                    );
                                    await playerNotifier.seekTo(newPosition); // 调用 Notifier 方法
                                    if (mounted) {
                                      // 确保组件未销毁
                                      setState(() => _tempSliderValue = -1); // 重置临时值
                                    }
                                  }
                                : null,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      child: Text(
                        CommonUtils.formatDuration(duration),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                VolumeControl(
                  volume: volume,
                  onVolumeChanged: (v) => playerNotifier.setVolume(v),
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onPressed: currentSong != null
                      ? () {
                          // 切换静音/恢复音量
                          if (volume > 0) {
                            playerNotifier.setVolume(0);
                          } else {
                            playerNotifier.setVolume(1);
                          }
                        }
                      : null,
                ),
                const SizedBox(
                  width: 10,
                ),
                // 播放列表按钮
                IconButton(
                  onPressed: () => _showPlaylist(context),
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  padding: EdgeInsets.zero,
                  iconSize: 14,
                  icon: Transform.translate(
                    offset: const Offset(-2, 0),
                    child: Icon(
                      SFIcons.sf_icon_listbullet,
                      size: 14,
                      color: activeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 播放列表弹窗（逻辑不变）
  void _showPlaylist(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '关闭',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface, // 适配主题色（优化）
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const Center(child: Text('开发中敬请期待..')),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        final curvedAnim = CurvedAnimation(parent: anim, curve: Curves.easeOut);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.3), // 从上方 30% 位置滑入（优化体验）
            end: Offset.zero,
          ).animate(curvedAnim),
          child: FadeTransition(opacity: curvedAnim, child: child),
        );
      },
    );
  }
}
