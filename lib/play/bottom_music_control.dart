import 'dart:ui';
import 'package:get/get.dart';
import 'dart:math' show Random;
import 'package:marquee_list/marquee_list.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class BottomMusicControl extends GetWidget<AudioController> {
  const BottomMusicControl({super.key});
  TextStyle _bodyText2Style(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          height: 1.4,
          fontSize: 12,
          color: Colors.white70,
        );
  }

  @override
  Widget build(BuildContext context) {
    final List<_Bubble> bubbles = List.generate(15, (index) => _Bubble());
    return SizedBox(
      height: 130,
      child: Obx(() {
        final bgImage = (controller.currentMusicInfo.value.artUri?.toString().isNotEmpty == true)
            ? controller.currentMusicInfo.value.artUri.toString()
            : (controller.playlist.isNotEmpty ? controller.playlist[controller.currentIndex].face : '');

        return ClipRRect(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. 背景图片（只在底部栏内显示）
                if (bgImage.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: bgImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Increased blur for a more "premium" glass look
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withValues(alpha: 0.4) // Darker for night mode
                          : Colors.black.withValues(alpha: 0.4), // Slightly lighter for day mode
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  child: _BubbleAnimator(
                    bubbles: bubbles,
                    primaryColor: Theme.of(context).splashColor,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10, left: 22, right: 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: ListTile(
                              splashColor: Colors.transparent,
                              tileColor: Colors.transparent,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              dense: true,
                              enableFeedback: false,
                              leading: controller.playlist.isNotEmpty
                                  ? Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: bgImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.music_note_rounded,
                                        color: Colors.white70,
                                      ),
                                    ),
                              title: controller.playlist.isNotEmpty
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: MarqueeList(
                                        scrollDuration: const Duration(seconds: 4),
                                        key: ValueKey(controller.playlist[controller.currentIndex].cid),
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Text(
                                            controller.playlist[controller.currentIndex].part,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              height: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Text(
                                      '暂无歌曲',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                              subtitle: controller.playlist.isNotEmpty
                                  ? Obx(() => Text(
                                        controller.currentMusicInfo.value.artist!.isNotEmpty
                                            ? controller.currentMusicInfo.value.artist!
                                            : controller.currentMediaInfo.name,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white60,
                                        ),
                                      ))
                                  : const Text(
                                      '请选择歌单',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white54,
                                      ),
                                    ),
                              onTap: () {
                                if (controller.playlist.isNotEmpty) {
                                  Get.toNamed(RoutePath.kmusicPage);
                                }
                              },
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(
                                    Icons.skip_previous_rounded,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                  onPressed: controller.previous,
                                ),
                                const SizedBox(width: 2),
                                Obx(
                                  () => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF3A3A).withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        )
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () => controller.isPlaying.value ? controller.pause() : controller.play(),
                                      child: Icon(
                                        controller.isPlaying.value
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_fill_rounded,
                                        size: 36,
                                        color: const Color(0xFFFF3A3A),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(
                                    Icons.skip_next_rounded,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                  onPressed: controller.next,
                                ),
                                const SizedBox(width: 2),
                                Obx(
                                  () => IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      controller.isFavorite.value
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      size: 24,
                                      color: controller.isFavorite.value ? Color(0xFFFF3A3A) : Colors.white70,
                                    ),
                                    onPressed: () {
                                      controller.toggleFavorite();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(() => ProgressBar(
                            progress: controller.currentPlayPosition.value,
                            barHeight: 5,
                            thumbRadius: 5,
                            thumbGlowRadius: 10,
                            baseBarColor: Colors.white.withValues(alpha: 0.15),
                            progressBarColor: Color(0xFFFF3A3A),
                            bufferedBarColor: Color(0xFFFF3A3A).withValues(alpha: 0.4),
                            thumbColor: Colors.white,
                            thumbGlowColor: Colors.white30,
                            timeLabelTextStyle: _bodyText2Style(context),
                            total: controller.currentMusicDuration.value,
                            onSeek: (duration) {
                              controller.seek(duration);
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Bubble {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double vx = (Random().nextDouble() - 0.5) * 0.002;
  double vy = (Random().nextDouble() - 0.5) * 0.002;
  double radius = 15 + Random().nextDouble() * 30;

  void update() {
    x += vx;
    y += vy;
    if (x < 0 || x > 1) vx *= -1;
    if (y < 0 || y > 1) vy *= -1;
  }
}

class _BubbleAnimator extends StatefulWidget {
  final List<_Bubble> bubbles;
  final Color primaryColor;
  const _BubbleAnimator({required this.bubbles, required this.primaryColor});

  @override
  State<_BubbleAnimator> createState() => _BubbleAnimatorState();
}

class _BubbleAnimatorState extends State<_BubbleAnimator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    _controller.addListener(() {
      for (var b in widget.bubbles) {
        b.update();
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BubblePainter(widget.bubbles, widget.primaryColor));
  }
}

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final Color primaryColor;
  _BubblePainter(this.bubbles, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (var b in bubbles) {
      final center = Offset(b.x * size.width, b.y * size.height);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.5),
            primaryColor.withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: b.radius));
      canvas.drawCircle(center, b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
