import 'dart:io';
import 'package:snacknload/snacknload.dart';
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
    final hasPrevious = ref.watch(playerNotifierProvider.select((s) => s.hasPrevious));
    final hasNext = ref.watch(playerNotifierProvider.select((s) => s.hasNext));

    final showVolumeControl = widget.containerWidth > 765;
    final showProgressControl = widget.containerWidth > 660;
    double progressLength = (widget.containerWidth - 520).clamp(254, 312);
    if (!showProgressControl) {
      progressLength = widget.containerWidth - 268;
    }
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
        vertical: showVolumeControl ? 10.0 : 5.0,
        horizontal: showVolumeControl ? 10.0 : 5.0,
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          // 歌曲封面（点击跳转播放页）
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
          const SizedBox(width: 12),
          // 歌曲信息（标题、歌手、进度条）
          SizedBox(
            width: progressLength,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 歌曲标题（横向滚动）
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    currentSong?.title ?? '未播放',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                // 歌手 + 时间（仅在宽屏显示时间）
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          currentSong?.artist ?? '选择歌曲开始播放',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (showProgressControl)
                      SizedBox(
                        width: 92,
                        child: Text(
                          '${CommonUtils.formatDuration(position)}/${CommonUtils.formatDuration(duration)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    const SizedBox(width: 30),
                  ],
                ),
                // 进度条（仅在宽屏显示）
                if (showProgressControl) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
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
                      const SizedBox(width: 30),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ],
            ),
          ),
          const Spacer(), // 右侧弹性空白
          // 音量控制（仅在宽屏显示）
          if (showVolumeControl) ...[
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    volume <= 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    size: 20,
                  ),
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
                SizedBox(
                  width: 100,
                  child: AnimatedTrackHeightSlider(
                    trackHeight: 4,
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: currentSong != null
                        ? (value) => playerNotifier.setVolume(value) // 实时更新音量
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
          // 播放模式按钮（仅在宽屏显示）
          if (showProgressControl) ...[
            // 随机播放按钮
            IconButton(
              iconSize: 20,
              icon: Icon(
                Icons.shuffle_rounded,
                color: playMode == PlayMode.shuffle ? activeColor : inactiveColor,
              ),
              onPressed: () {
                // 切换随机/顺序模式
                if (playMode == PlayMode.shuffle) {
                  playerNotifier.setPlayMode(PlayMode.sequence);
                } else {
                  playerNotifier.setPlayMode(PlayMode.shuffle);
                }
              },
            ),
            // 循环模式按钮（顺序→循环→单曲循环）
            IconButton(
              iconSize: 20,
              icon: Icon(
                playMode == PlayMode.singleLoop ? Icons.repeat_one_rounded : Icons.repeat_rounded,
                color: (playMode == PlayMode.loop || playMode == PlayMode.singleLoop) ? activeColor : inactiveColor,
              ),
              onPressed: () {
                // 切换循环模式
                if (playMode == PlayMode.singleLoop) {
                  playerNotifier.setPlayMode(PlayMode.sequence);
                } else {
                  playerNotifier.setPlayMode(
                    playMode == PlayMode.loop ? PlayMode.singleLoop : PlayMode.loop,
                  );
                }
              },
            ),
            const SizedBox(width: 10),
          ],
          // 核心控制按钮（上一首、播放/暂停、下一首、播放列表）
          Row(
            children: [
              // 上一首
              IconButton(
                color: activeColor,
                icon: const Icon(Icons.skip_previous_rounded, size: 40),
                // 顺序模式下无 previous 时禁用
                onPressed: (playMode == PlayMode.sequence && !hasPrevious)
                    ? null
                    : () async {
                        try {
                          await playerNotifier.previous();
                        } catch (e) {
                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('播放失败: $e')),
                            );
                          }
                        }
                      },
              ),
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
                    onPressed: currentSong != null
                        ? () async {
                            try {
                              await playerNotifier.togglePlay(); // 切换播放状态
                            } catch (e) {
                              if (mounted) {
                                SnackNLoad.showToast('操作失败: $e');
                              }
                            }
                          }
                        : null,
                  ),
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
                onPressed: (playMode == PlayMode.sequence && !hasNext)
                    ? null
                    : () async {
                        try {
                          await playerNotifier.next();
                        } catch (e) {
                          if (mounted) {
                            SnackNLoad.showToast('操作失败: $e');
                          }
                        }
                      },
              ),
              // 播放列表按钮
              IconButton(
                onPressed: () => _showPlaylist(context),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                padding: EdgeInsets.zero,
                iconSize: 16,
                icon: Transform.translate(
                  offset: const Offset(-2, 0),
                  child: Icon(
                    SFIcons.sf_icon_listbullet,
                    size: 16,
                    color: activeColor,
                  ),
                ),
              ),
            ],
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
