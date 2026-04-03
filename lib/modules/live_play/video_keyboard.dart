import 'package:flutter/services.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/modules/live_play/widgets/video_player/video_controller.dart';

class VideoKeyboardShortcuts extends StatelessWidget {
  final VideoController controller;
  final Widget child;

  const VideoKeyboardShortcuts({super.key, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.mediaPlay): () => controller.player.play(),
        const SingleActivator(LogicalKeyboardKey.mediaPause): () => controller.player.pause(),
        const SingleActivator(LogicalKeyboardKey.space): () => controller.player.playOrPause(),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () async {
          double? volume = controller.player.state.volume;
          volume = (volume) + 5;
          volume = volume.clamp(0, 100);
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () async {
          double? volume = controller.player.state.volume;
          volume = (volume) - 5;
          volume = volume.clamp(0, 100);
        },
        const SingleActivator(LogicalKeyboardKey.escape): () => controller.toggleFullScreen(),
      },
      child: child,
    );
  }
}
