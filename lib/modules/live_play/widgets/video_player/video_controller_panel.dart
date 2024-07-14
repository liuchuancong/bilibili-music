import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bilibilimusic/modules/live_play/widgets/video_player/video_controller.dart';

class VideoControllerPanel extends StatefulWidget {
  final VideoController controller;

  const VideoControllerPanel({
    super.key,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _VideoControllerPanelState();
}

class _VideoControllerPanelState extends State<VideoControllerPanel> {
  static const barHeight = 70.0;

  // Video controllers
  VideoController get controller => widget.controller;
  double currentVolumn = 1.0;
  bool showVolumn = true;
  Timer? _hideVolumn;
  void restartTimer() {
    _hideVolumn?.cancel();
    _hideVolumn = Timer(const Duration(seconds: 1), () {
      setState(() => showVolumn = true);
    });
    setState(() => showVolumn = false);
  }

  @override
  void dispose() {
    _hideVolumn?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.enableController();
    });
  }

  void updateVolumn(double? volume) {
    restartTimer();
    setState(() {
      currentVolumn = volume!;
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    iconData = currentVolumn <= 0
        ? Icons.volume_mute
        : currentVolumn < 0.5
            ? Icons.volume_down
            : Icons.volume_up;
    return Material(
      type: MaterialType.transparency,
      child: Focus(
        autofocus: true,
        child: Obx(() => controller.hasError.value
            ? ErrorWidget(controller: controller)
            : MouseRegion(
                onHover: (event) => controller.enableController(),
                onExit: (event) {
                  controller.showControllerTimer?.cancel();
                  controller.showController.toggle();
                },
                child: Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        opacity: !showVolumn ? 0.8 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Card(
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(iconData, color: Colors.white),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 100,
                                      height: 20,
                                      child: LinearProgressIndicator(
                                        value: currentVolumn,
                                        backgroundColor: Colors.white38,
                                        valueColor: AlwaysStoppedAnimation(
                                          Theme.of(context).indicatorColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.enableController();
                      },
                      onDoubleTap: () {
                        controller.toggleFullScreen();
                      },
                      child: BrightnessVolumnDargArea(
                        controller: controller,
                      ),
                    ),
                    // PlayGroupButton(
                    //   controller: controller,
                    // ),
                    BottomActionBar(
                      controller: controller,
                      barHeight: barHeight,
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}

class PlayGroupButton extends StatelessWidget {
  const PlayGroupButton({super.key, required this.controller});

  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedOpacity(
          opacity: controller.showController.value ? 0.9 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SeekToButton(isLeft: true, controller: controller),
                    PlayPauseButton(
                      controller: controller,
                    ),
                    SeekToButton(isLeft: false, controller: controller),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.controller,
  });

  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "加载失败",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () => controller.refresh(),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
            child: const Text(
              "点击重试",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class BrightnessVolumnDargArea extends StatefulWidget {
  const BrightnessVolumnDargArea({
    super.key,
    required this.controller,
  });

  final VideoController controller;

  @override
  State<BrightnessVolumnDargArea> createState() => BrightnessVolumnDargAreaState();
}

class BrightnessVolumnDargAreaState extends State<BrightnessVolumnDargArea> {
  VideoController get controller => widget.controller;

  // Darg bv ui control
  Timer? _hideBVTimer;
  bool _hideBVStuff = true;
  bool _isDargLeft = true;
  double _updateDargVarVal = 1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _hideBVTimer?.cancel();
    super.dispose();
  }

  void updateVolumn(double? volume) {
    _isDargLeft = false;
    _cancelAndRestartHideBVTimer();
    setState(() {
      _updateDargVarVal = volume!;
    });
  }

  void _cancelAndRestartHideBVTimer() {
    _hideBVTimer?.cancel();
    _hideBVTimer = Timer(const Duration(seconds: 1), () {
      setState(() => _hideBVStuff = true);
    });
    setState(() => _hideBVStuff = false);
  }

  void _onVerticalDragUpdate(Offset postion, Offset delta) async {
    if (delta.distance < 0.2) return;

    // fix darg left change to switch bug
    final width = MediaQuery.of(context).size.width;
    final dargLeft = (postion.dx > (width / 2)) ? false : true;
    // disable windows brightness
    if (Platform.isWindows && dargLeft) return;
    if (_hideBVStuff || _isDargLeft != dargLeft) {
      _isDargLeft = dargLeft;
      if (_isDargLeft) {
        await controller.brightness().then((double v) {
          setState(() => _updateDargVarVal = v);
        });
      } else {
        await controller.volumn().then((double? v) {
          setState(() => _updateDargVarVal = v!);
        });
      }
    }
    _cancelAndRestartHideBVTimer();

    double dragRange =
        (delta.direction < 0 || delta.direction > pi) ? _updateDargVarVal + 0.01 : _updateDargVarVal - 0.01;
    // 是否溢出
    dragRange = min(dragRange, 1.0);
    dragRange = max(dragRange, 0.0);
    // 亮度 & 音量
    if (_isDargLeft) {
      controller.setBrightness(dragRange);
    } else {
      controller.setVolumn(dragRange);
    }
    setState(() => _updateDargVarVal = dragRange);
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    if (_isDargLeft) {
      iconData = _updateDargVarVal <= 0
          ? Icons.brightness_low
          : _updateDargVarVal < 0.5
              ? Icons.brightness_medium
              : Icons.brightness_high;
    } else {
      iconData = _updateDargVarVal <= 0
          ? Icons.volume_mute
          : _updateDargVarVal < 0.5
              ? Icons.volume_down
              : Icons.volume_up;
    }

    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _onVerticalDragUpdate(event.localPosition, event.scrollDelta);
        }
      },
      child: GestureDetector(
        onVerticalDragUpdate: (details) => _onVerticalDragUpdate(details.localPosition, details.delta),
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: AnimatedOpacity(
            opacity: !_hideBVStuff ? 0.8 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Card(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(iconData, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 100,
                          height: 20,
                          child: LinearProgressIndicator(
                            value: _updateDargVarVal,
                            backgroundColor: Colors.white38,
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).indicatorColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Bottom action bar widgets
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.controller,
    required this.barHeight,
  });

  final VideoController controller;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedPositioned(
          bottom: controller.showController.value ? 0 : -barHeight,
          left: 0,
          right: 0,
          height: barHeight,
          duration: const Duration(milliseconds: 300),
          child: Container(
            height: barHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.black54,
            ),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    SwitchButton(controller: controller, isLeft: true),
                    SeekToButton(isLeft: true, controller: controller),
                    PlayPauseButton(
                      controller: controller,
                    ),
                    SeekToButton(isLeft: false, controller: controller),
                    SwitchButton(controller: controller, isLeft: false),
                    TimeSliderButton(controller: controller),
                    const Spacer(),
                    MuteButton(controller: controller),
                    ExpandButton(controller: controller),
                  ],
                ),
                ProgressBar(
                  progress: Duration(seconds: controller.position.value),
                  barHeight: 2,
                  thumbRadius: 4,
                  thumbGlowRadius: 8,
                  progressBarColor: Colors.white,
                  bufferedBarColor: Colors.white38,
                  thumbColor: Colors.white,
                  thumbGlowColor: Colors.white,
                  total: Duration(seconds: controller.duration.value),
                  timeLabelTextStyle: const TextStyle(fontSize: 0),
                  onSeek: (duration) {
                    controller.betterPlayerController.seekTo(duration);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class SeekToButton extends StatelessWidget {
  const SeekToButton({super.key, required this.controller, required this.isLeft});

  final VideoController controller;
  final bool isLeft;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isLeft ? controller.skipBack() : controller.skipForward(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Icon(
          isLeft ? Icons.replay_5_outlined : Icons.forward_5_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SwitchButton extends StatelessWidget {
  const SwitchButton({super.key, required this.controller, required this.isLeft});

  final VideoController controller;
  final bool isLeft;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isLeft ? controller.livePlayController.playPrevious() : controller.livePlayController.playNext(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Icon(
          isLeft ? Icons.fast_rewind_rounded : Icons.fast_forward_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, required this.controller});

  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.togglePlayPause(),
      child: Obx(() => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            child: Icon(
              controller.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
            ),
          )),
    );
  }
}

class MuteButton extends StatelessWidget {
  const MuteButton({super.key, required this.controller});

  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.toggleMute(),
      child: Obx(() => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            child: Icon(
              controller.isMuted.value ? Icons.volume_mute_sharp : Icons.volume_up_rounded,
              color: Colors.white,
            ),
          )),
    );
  }
}

class TimeSliderButton extends StatelessWidget {
  const TimeSliderButton({super.key, required this.controller});

  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          child: Text(
            '${controller.second2HMS(controller.position.value)} - ${controller.second2HMS(controller.duration.value)}',
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key, required this.controller});

  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.refresh(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: const Icon(
          Icons.refresh_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ExpandButton extends StatelessWidget {
  const ExpandButton({super.key, required this.controller});

  final VideoController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.toggleFullScreen(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Obx(() => Icon(
              controller.isFullscreen.value ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
              color: Colors.white,
              size: 26,
            )),
      ),
    );
  }
}
