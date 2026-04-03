import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:bilibilimusic/utils/text_util.dart';
import 'package:bilibilimusic/utils/cache_manager.dart';
import 'package:bilibilimusic/models/live_play_quality.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bilibilimusic/modules/live_play/video_keyboard.dart';
import 'package:bilibilimusic/modules/live_play/live_play_controller.dart';
import 'package:bilibilimusic/modules/live_play/widgets/video_player/video_player.dart';

class LivePlayPage extends GetView<LivePlayController> {
  const LivePlayPage({super.key});

  static const double _tabletBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    WakelockPlus.toggle(enable: true);

    return Obx(() {
      final isFullScreen = controller.screenMode.value == VideoMode.fullscreen;

      // 全屏时不显示 AppBar
      if (isFullScreen) {
        Widget mainUI = Scaffold(
          backgroundColor: Colors.black,
          body: _buildPlayerSection(true),
        );

        if (controller.videoController != null) {
          mainUI = VideoKeyboardShortcuts(
            controller: controller.videoController!,
            child: mainUI,
          );
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            controller.videoController?.toggleFullScreen();
          },
          child: mainUI,
        );
      }

      // 正常模式 → 显示 AppBar（解决 Android 无返回栏）
      Widget mainUI = Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(Get.context!).pop(),
          ),
          title: Text(
            controller.mediaInfo.title,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: _buildAdaptiveLayout(),
      );

      if (controller.videoController != null) {
        mainUI = VideoKeyboardShortcuts(
          controller: controller.videoController!,
          child: mainUI,
        );
      }

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.of(Get.context!).pop();
        },
        child: mainUI,
      );
    });
  }

  Widget _buildAdaptiveLayout() {
    return LayoutBuilder(builder: (context, constraints) {
      bool isTablet = constraints.maxWidth >= _tabletBreakpoint;

      if (isTablet) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: Center(child: _buildPlayerSection(false))),
            const VerticalDivider(width: 1, color: Colors.black12),
            const Expanded(
              flex: 2,
              child: SingleChildScrollView(child: ResolutionsRow()),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            _buildPlayerSection(false),
            const Expanded(
              child: SingleChildScrollView(child: ResolutionsRow()),
            ),
          ],
        );
      }
    });
  }

  Widget _buildPlayerSection(bool isFullScreen) {
    return Obx(() {
      Widget player;
      if (controller.success.value && controller.videoController != null) {
        player = VideoPlayer(controller: controller.videoController!);
      } else {
        player = _buildPlaceholder();
      }

      return isFullScreen
          ? Container(color: Colors.black, child: player)
          : AspectRatio(aspectRatio: 16 / 9, child: Container(color: Colors.black, child: player));
    });
  }

  // 移除占位图里的返回按钮（现在用系统 AppBar）
  Widget _buildPlaceholder() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: controller.mediaInfo.pic,
          cacheManager: CustomCacheManager.instance,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => const Icon(Icons.live_tv, size: 50, color: Colors.white),
        ),
        const Center(child: CircularProgressIndicator(color: Colors.white70)),
      ],
    );
  }
}

/// 信息展示区（适配白色背景）
class ResolutionsRow extends GetView<LivePlayController> {
  const ResolutionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.mediaInfo.title,
                  style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.whatshot, size: 16, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(readableCount(controller.mediaInfo.favorite.toString()),
                      style: const TextStyle(color: Colors.black54)),
                  const Spacer(),
                  if (controller.success.value) _buildQualityBtn(),
                ],
              ),
              const Divider(height: 32, color: Colors.black12),
            ],
          ),
        ));
  }

  Widget _buildQualityBtn() {
    final qualities = LivePlayQualityList.getQuality(controller.videoInfoData.acceptQuality);
    final current = qualities.firstWhereOrNull((q) => q.value == controller.videoInfoData.quality)?.quality ?? '自动';

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black26),
        foregroundColor: Get.theme.colorScheme.onSurface,
      ),
      onPressed: () {
        Get.bottomSheet(
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                ...qualities.map((q) => ListTile(
                      title: Text(q.quality, style: TextStyle(color: Colors.black87), textAlign: TextAlign.center),
                      onTap: () {
                        controller.setResolution(q.value.toString());
                        Navigator.of(Get.context!).pop();
                      },
                    )),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
      child: Text(current),
    );
  }
}
