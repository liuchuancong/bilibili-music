import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:marquee_list/marquee_list.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/play/blur_back_ground.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bilibilimusic/play/lyric/lyrics_reader_model.dart';
import 'package:bilibilimusic/play/lyric/lyric_ui/ui_netease.dart';
import 'package:bilibilimusic/play/lyric/lyrics_model_builder.dart';
import 'package:bilibilimusic/play/lyric/lyrics_reader_widget.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  MusicPageWidgetState createState() => MusicPageWidgetState();
}

class MusicPageWidgetState extends State<MusicPage> with TickerProviderStateMixin {
  late AnimationController waveController;

  late Animation animation;

  final AudioController audioController = Get.find<AudioController>();
  late LyricsReaderModel lyricModel;
  var lyricUI = UINetease();
  @override
  void initState() {
    setTransparentStatusBar();
    waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    audioController.lyricStatus.listen((p0) {
      lyricModel = LyricsModelBuilder.create().bindLyricToMain(audioController.normalLyric.value).getModel();
      if (mounted) {
        setState(() {});
      }
    });
    lyricModel = LyricsModelBuilder.create().bindLyricToMain(audioController.normalLyric.value).getModel();
    super.initState();
  }

  // 你可以在需要的地方调用这个方法，比如在main函数之前
  void setTransparentStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 设置状态栏背景为透明
        statusBarBrightness: Brightness.dark, // 根据你的背景颜色调整文字颜色
      ),
    );
  }

  @override
  void dispose() {
    waveController.dispose();
    super.dispose();
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
    return LyricsReader(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      model: lyricModel,
      position: audioController.currentMusicPosition.value.inMilliseconds,
      lyricUi: lyricUI,
      playing: audioController.isPlaying.value,
      size: Size(double.infinity, MediaQuery.of(context).size.height * 0.55),
      emptyBuilder: () => Center(
        child: Text(
          audioController.lyricStatus.value == LyricStatus.loading ? '歌词加载中...' : '暂无歌词',
          style: lyricUI.getOtherMainTextStyle(),
        ),
      ),
      onTap: setLyricState,
      selectLineBuilder: (progress, confirm) {
        return Row(
          children: [
            IconButton(
                onPressed: () {
                  confirm.call();
                  setState(() {
                    audioController.seek(Duration(milliseconds: progress));
                  });
                },
                icon: const Icon(Icons.play_arrow_outlined, color: Colors.white)),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                height: 1,
                width: double.infinity,
              ),
            ),
            Text(
              formatDuration(progress ~/ 1000).toString(),
              style: const TextStyle(color: Colors.white),
            )
          ],
        );
      },
    );
  }

  Widget _buildImage() {
    double expandedSize = Get.width;
    return GestureDetector(
      onTap: setLyricState,
      child: SizedBox(
        width: expandedSize * 0.8,
        height: expandedSize * 0.8,
        child: RippleWave(
          childTween: Tween(begin: 1, end: 1.0),
          color: Colors.white.withOpacity(0.5),
          repeat: true,
          waveCount: 4,
          animationController: waveController,
          child: SizedBox(
            width: 200,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                imageUrl: audioController.currentMusicInfo.value['cover']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MarqueeList(
              key: ValueKey(audioController.playlist[audioController.currentIndex].cid),
              scrollDirection: Axis.horizontal,
              scrollDuration: const Duration(seconds: 2),
              children: [
                Text(
                  audioController.currentMusicInfo.value['title']!,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(audioController.currentMusicInfo.value['author']!,
                style: _bodyText2Style(context), maxLines: 1, overflow: TextOverflow.ellipsis)
          ],
        ));
  }

  Widget _buildSeekBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Obx(() => ProgressBar(
            progress: audioController.currentMusicPosition.value,
            barHeight: 5,
            thumbRadius: 4,
            thumbGlowRadius: 8,
            baseBarColor: Colors.white.withOpacity(0.5),
            progressBarColor: Colors.red[700],
            bufferedBarColor: Colors.red[300],
            thumbColor: Colors.white,
            thumbGlowColor: Colors.white,
            timeLabelTextStyle: _bodyText2Style(context),
            total: audioController.currentMusicDuration.value,
            onSeek: (duration) {
              audioController.seek(duration);
            },
          )),
    );
  }

  Widget _buildPlayModelIcon() {
    if (audioController.playMode.value == PlayMode.listLoop) {
      return IconButton(
          icon: const Icon(
            Icons.repeat_rounded,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () => audioController.changePlayMode());
    } else if (audioController.playMode.value == PlayMode.singleLoop) {
      return IconButton(
          icon: const Icon(
            Icons.repeat_one,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () => audioController.changePlayMode());
    } else {
      return IconButton(
          icon: const Icon(
            Icons.shuffle,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () => audioController.changePlayMode());
    }
  }

  Widget _buildControlsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(
          () => _buildPlayModelIcon(),
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
            size: 32,
            color: Colors.white,
          ),
          onPressed: audioController.previous,
        ),
        Obx(
          () => IconButton(
            icon: Icon(
              audioController.isPlaying.value ? Icons.pause : Icons.play_arrow,
              size: 32,
              color: Colors.white,
            ),
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
          icon: const Icon(
            Icons.skip_next,
            size: 32,
            color: Colors.white,
          ),
          onPressed: audioController.next,
        ),
        IconButton(
          icon: const Icon(
            Icons.menu_open_rounded,
            size: 32,
            color: Colors.white,
          ),
          onPressed: audioController.previous,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Obx(() => BlurBackground(imageUrl: audioController.currentMusicInfo.value['cover']!)),
          Column(
            children: [
              const SizedBox(height: 30),
              _buildTopBar(),
              const SizedBox(height: 10),
              _buildCenterSection(),
              const SizedBox(height: 10),
              _buildTitle(),
              const SizedBox(height: 10),
              _buildSeekBar(),
              const SizedBox(height: 20),
              _buildControlsBar(),
              const SizedBox(height: 30),
            ],
          )
        ],
      ),
    );
  }
}
