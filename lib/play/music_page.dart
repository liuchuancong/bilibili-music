import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:marquee_list/marquee_list.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
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

  bool hasDisposed = false;

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
    lyricModel = LyricsModelBuilder.create().bindLyricToMain(audioController.normalLyric.value).getModel();

    audioController.normalLyric.addListener(() {
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          lyricModel = LyricsModelBuilder.create().bindLyricToMain(audioController.normalLyric.value).getModel();
        });
      });
    });

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
    if (!hasDisposed) {
      hasDisposed = true;
      waveController.dispose();
    }
    super.dispose();
  }

  void setLyricState() {
    audioController.showLyric.toggle();
  }

  void showLyricDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('选择歌词', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(Get.context!).pop();
                    },
                  )
                ],
              ),
              const Divider(height: 1, color: Colors.black)
            ],
          ),
          content: FutureBuilder<List<LyricResults>>(
              future: BiliBiliSite().getSearchLyrics(
                  audioController.currentMusicInfo.value['title']!, audioController.currentMusicInfo.value['author']!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  log(snapshot.toString(), name: 'lyric_dialog');
                  if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                    return SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text('暂无歌词'),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!
                            .map((e) => ListTile(
                                  title: Text(
                                    e.title.isNotEmpty ? e.title : audioController.currentMediaInfo.part,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    e.artist.isNotEmpty ? e.artist : '未知歌手',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    audioController.normalLyric.value = e.lyrics;
                                    lyricModel = LyricsModelBuilder.create()
                                        .bindLyricToMain(audioController.normalLyric.value)
                                        .getModel();
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                  );
                }
              }),
        );
      },
    );
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
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 18.0, right: 18.0),
                  onPressed: () {
                    showLyricDialog();
                  },
                  icon: const Icon(
                    Icons.lyrics_outlined,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 18.0, right: 18.0),
                  onPressed: () {
                    AppNavigator.toLiveRoomDetail(mediaInfo: audioController.currentMediaInfo);
                  },
                  icon: const Icon(
                    Icons.slow_motion_video_sharp,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 18.0, right: 18.0),
                  onPressed: () {
                    showMusicAlubmSelectorDialog();
                  },
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                  ),
                ),
              ])),
        ],
      ),
    );
  }

  void showMusicAlubmSelectorDialog() {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('添加到歌单'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  children: audioController.settingsService.musicAlbum
                      .where((el) => el.status == VideoStatus.customized)
                      .map(
                        (BilibiliVideo item) => TextButton(
                          onPressed: () {
                            if (audioController.settingsService
                                .isExitMusicAlbum(item.id, audioController.currentMediaInfo)) {
                              SmartDialog.showToast('歌曲已在歌单中');
                            } else {
                              audioController.settingsService.addMusicToAlbum(item.id, audioController.playlist);
                              SmartDialog.showToast('添加成功');
                            }
                            audioController.isFavorite.value =
                                audioController.settingsService.isInFavoriteMusic(audioController.currentMediaInfo);
                            Navigator.of(Get.context!).pop();
                          },
                          child: Text(item.title!),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        });
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
              child: audioController.currentMusicInfo.value['cover']!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: audioController.currentMusicInfo.value['cover']!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.data_usage_rounded),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 100,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MarqueeList(
                scrollDirection: Axis.horizontal,
                scrollDuration: const Duration(seconds: 2),
                children: [
                  Obx(() => Text(
                        audioController.currentMediaInfo.part,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              Obx(() => Text(audioController.currentMediaInfo.name,
                  style: _bodyText2Style(context), maxLines: 1, overflow: TextOverflow.ellipsis))
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: IconButton(
            icon: Obx(() => Icon(
                  audioController.isFavorite.value ? Icons.favorite : Icons.favorite_border_rounded,
                  size: 32,
                  color: audioController.isFavorite.value ? Colors.red : Colors.white,
                )),
            onPressed: () {
              audioController.toggleFavorite();
            },
          ),
        ),
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
          onPressed: audioController.showMenuMedias,
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
