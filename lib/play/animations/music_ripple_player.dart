import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ripple_wave/ripple_wave.dart'; 
import 'package:cached_network_image/cached_network_image.dart';
// 注意：确保你的项目中已经导入了 RippleWave 所在的库

class MusicRipplePlayer extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;
  final AnimationController animationController;
  final double size;
  final Color rippleColor;

  const MusicRipplePlayer({
    super.key,
    required this.imageUrl,
    required this.onTap,
    required this.animationController,
    this.size = 200,
    this.rippleColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // 外部容器大小（波纹扩散范围）
    double containerSize = Get.width * 0.8;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: containerSize,
        height: containerSize,
        child: RippleWave(
          childTween: Tween(begin: 1.0, end: 1.0),
          color: rippleColor.withValues(alpha: 0.5),
          repeat: true,
          waveCount: 4,
          animationController: animationController,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.music_note, color: Colors.white54, size: 50),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
