import 'dart:async';
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

  bool isShowVolume = false;

  final AudioController audioController = Get.find<AudioController>();
  late LyricsReaderModel lyricModel;
  var lyricUI = UINetease();

  GlobalKey volumeButton = GlobalKey();
  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;
  static const double _barHeight = 150;

  Timer? timer;
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

  void setTransparentStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    if (!hasDisposed) {
      hasDisposed = true;
      waveController.dispose();
    }
    _hideVolumeBar();
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

  void _showVolumeBar() {
    final renderBox = volumeButton.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + (renderBox.size.width - 40) / 2,
        top: position.dy - _barHeight - 8,
        width: 40,
        height: _barHeight,
        child: _buildVolumeBar(),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) {
      setState(() {
        isShowVolume = true;
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 2), _hideVolumeBar);
      });
    }
  }

  void _hideVolumeBar() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => isShowVolume = false);
    }
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  void _toggleVolumeBar() {
    if (isShowVolume) {
      _hideVolumeBar();
    } else {
      _showVolumeBar();
    }
  }

  void _handleVolumeDrag(DragUpdateDetails details) {
    final maxDeltaPerUpdate = _barHeight * 0.1;
    final clampedDelta = details.delta.dy.clamp(-maxDeltaPerUpdate, maxDeltaPerUpdate);
    if (mounted) {
      setState(() {
        isShowVolume = true;
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 2), _hideVolumeBar);
      });
    }
    final deltaRatio = -clampedDelta / _barHeight;
    final newVolume = (audioController.currentVolumn.value + deltaRatio).clamp(0.0, 1.0);

    if (newVolume != audioController.currentVolumn.value) {
      setState(() {
        audioController.currentVolumn.value = double.parse(newVolume.toStringAsFixed(2));
      });
      audioController.setVolume(newVolume);
      _overlayEntry?.markNeedsBuild();
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 2), _hideVolumeBar);
    }
  }

  Widget _buildVolumeBar() {
    final sliderPosition = (audioController.currentVolumn.value * _barHeight).clamp(10, _barHeight - 25).toDouble();
    return GestureDetector(
      onVerticalDragUpdate: _handleVolumeDrag,
      onTap: _hideVolumeBar,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
            colors: [Colors.white24, Colors.white12],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(child: VerticalDivider(color: Color.fromRGBO(233, 43, 43, 1), thickness: 3)),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: sliderPosition,
              child: const CircleAvatar(radius: 6, backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
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
          color: Colors.white.withValues(alpha: 0.5),
          repeat: true,
          waveCount: 4,
          animationController: waveController,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: audioController.currentMusicInfo.value['cover']!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: audioController.currentMusicInfo.value['cover']!,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: audioController.currentMediaInfo.face,
                          fit: BoxFit.cover,
                        ),
                )),
          ),
        ),
      ),
    );
  }

  IconData getVolumeIcon() {
    IconData iconData;
    iconData = audioController.currentVolumn.value <= 0
        ? Icons.volume_off
        : audioController.currentVolumn.value < 0.5
            ? Icons.volume_down
            : Icons.volume_up;
    return iconData;
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          key: volumeButton,
          child: GestureDetector(
            child: Obx(() => Icon(
                  getVolumeIcon(),
                  size: 32,
                  color: Colors.white,
                )),
            onTapDown: (TapDownDetails details) {
              _toggleVolumeBar();
            },
          ),
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
              Obx(() => Text(
                  audioController.currentMusicInfo.value['author']!.isNotEmpty
                      ? audioController.currentMusicInfo.value['author']!
                      : audioController.currentMediaInfo.name,
                  style: _bodyText2Style(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis))
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
            baseBarColor: Colors.white.withValues(alpha: 0.5),
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
              if (audioController.isPlaying.value) {
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

  void globalTapHandler(TapDownDetails details) {
    if (_overlayEntry == null) return;
    final renderBox = volumeButton.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    if (!(position.dx <= details.globalPosition.dx &&
        position.dx + size.width >= details.globalPosition.dx &&
        position.dy <= details.globalPosition.dy &&
        position.dy + size.height >= details.globalPosition.dy)) {
      _hideVolumeBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GestureDetector(
        onTapDown: globalTapHandler,
        child: Stack(
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
      ),
    );
  }
}
