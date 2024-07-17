import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:marquee_list/marquee_list.dart';
import 'package:bilibilimusic/play/painter.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/play/blur_back_ground.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  MusicPageWidgetState createState() => MusicPageWidgetState();
}

class MusicPageWidgetState extends State<MusicPage> with TickerProviderStateMixin {
  late AnimationController controller, waveController;

  late Animation animation;

  final AudioController audioController = Get.find<AudioController>();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 15));
    waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    super.initState();
  }

  void setLyricState() {
    audioController.showLyric.toggle();
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              padding: const EdgeInsets.all(18.0),
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.navigate_before,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCenterSection() {
    return Expanded(
      child: Obx(
        () => AnimatedCrossFade(
          crossFadeState: audioController.showLyric.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Center(
                  key: bottomChildKey,
                  child: bottomChild,
                ),
                Center(
                  key: topChildKey,
                  child: topChild,
                ),
              ],
            );
          },
          firstChild: _buildImage(),
          secondChild: _buildLyric(),
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  TextStyle _bodyText2Style(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(height: 2, fontSize: 16, color: Colors.white);
  }

  Color highlightColor() {
    return Theme.of(Get.context!).textTheme.bodyMedium!.color!;
  }

  Widget _buildLyric() {
    if (audioController.lyricContent.value.isNotEmpty) {
      final style = _bodyText2Style(context);
      style.copyWith(color: style.color!.withOpacity(0.7));

      return LayoutBuilder(
        builder: (context, constraints) {
          return ShaderMask(
            blendMode: BlendMode.dstATop,
            shaderCallback: (Rect bounds) {
              return RadialGradient(
                center: Alignment.topLeft,
                radius: 1.0,
                colors: <Color>[Colors.yellow, Colors.deepOrange.shade900],
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(),
            ),
          );
        },
      );
    } else {
      final style = _bodyText2Style(context);
      return Center(
        child: Text('暂无歌词', style: style),
      );
    }
  }

  Widget _buildImage() {
    double expandedSize = Get.width;
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              painter: RingOfCirclesPainter(Colors.white, waveController.value),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(-controller.value * 2 * pi),
                child: GestureDetector(
                  onTap: setLyricState,
                  child: SizedBox(
                      width: expandedSize * 0.8,
                      height: expandedSize * 0.8,
                      child: Center(
                          child: SizedBox(
                        width: 200,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: CachedNetworkImage(
                            imageUrl: audioController.playlist[audioController.currentIndex].pic,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))),
                ),
              ),
            ),
          ],
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300], // 可以选择你喜欢的颜色
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // 更改颜色和不透明度以达到你想要的阴影效果
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3), // 改变偏移量来调整阴影位置
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        MarqueeList(
          key: ValueKey(audioController.playlist[audioController.currentIndex].cid),
          scrollDirection: Axis.horizontal,
          scrollDuration: const Duration(seconds: 2),
          children: [
            Text(
              audioController.playlist[audioController.currentIndex].part,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(audioController.playlist[audioController.currentIndex].name, style: _bodyText2Style(context))
      ],
    );
  }

  Widget _buildSeekBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Obx(() => ProgressBar(
            progress: audioController.currentMusicPosition.value,
            barHeight: 5,
            thumbRadius: 4,
            thumbGlowRadius: 8,
            baseBarColor: Colors.white.withOpacity(0.2),
            progressBarColor: Colors.white.withOpacity(0.2),
            bufferedBarColor: Colors.white.withOpacity(0.1),
            thumbColor: Colors.white,
            thumbGlowColor: Colors.white,
            timeLabelTextStyle: _bodyText2Style(context),
            total: audioController.currentMusicDuration.value,
            onSeek: (duration) {},
          )),
    );
  }

  Widget _buildControlsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: audioController.previous,
        ),
        Obx(
          () => IconButton(
            icon: Icon(audioController.isPlaying.value ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (audioController.audioPlayer.playing) {
                audioController.pause();
              } else {
                audioController.play();
              }
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: audioController.next,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlurBackground(imageUrl: audioController.playlist[audioController.currentIndex].pic),
            Column(
              children: [
                const SizedBox(height: 14),
                _buildTopBar(),
                const SizedBox(height: 80),
                _buildCenterSection(),
                const SizedBox(height: 10),
                _buildTitle(),
                const SizedBox(height: 10),
                _buildSeekBar(),
                const SizedBox(height: 30),
                _buildControlsBar(),
                const SizedBox(height: 30),
              ],
            )
          ],
        ),
      ),
    );
  }
}
