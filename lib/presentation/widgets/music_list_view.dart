import 'dart:io';
import 'package:snacknload/snacknload.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/utils/common_utils.dart';
import 'package:bilibilimusic/services/player_provider.dart';
import 'package:bilibilimusic/database/database_manager.dart';
import 'package:bilibilimusic/services/music_import_service.dart';
import 'package:bilibilimusic/presentation/widgets/song_action_menu.dart';
import 'package:bilibilimusic/presentation/widgets/themed_background.dart';

class MusicListView extends ConsumerStatefulWidget {
  final List<Song> songs;
  final ScrollController? scrollController;
  final bool showCheckbox;
  final List<int> checkedIds;
  final VoidCallback? onSongDeleted;
  final void Function(Song song, int? index)? onSongUpdated;
  final Function(Song, List<Song>, int)? onSongPlay;
  final Function(int, bool)? onCheckboxChanged;

  const MusicListView({
    super.key,
    required this.songs,
    this.scrollController,
    this.showCheckbox = false,
    this.checkedIds = const [],
    this.onSongDeleted,
    this.onSongUpdated,
    this.onSongPlay,
    this.onCheckboxChanged,
  });

  @override
  ConsumerState<MusicListView> createState() => _MusicListViewState();
}

class _MusicListViewState extends ConsumerState<MusicListView> {
  int? _hoveredIndex;
  bool _isScrolling = false;
  // 为每个歌曲的收藏状态创建 ValueNotifier
  final Map<int, ValueNotifier<bool>> _favoriteNotifiers = {};

  void _handleSongPlay(int index) {
    if (widget.onSongPlay != null) {
      widget.onSongPlay!(widget.songs[index], widget.songs, index);
    } else {
      // 默认播放行为
      ref.read(playerNotifierProvider.notifier).playSong(
            widget.songs[index],
            playlist: widget.songs,
            index: index,
          );
    }
  }

  void _handleFavoriteToggle(int index) {
    final song = widget.songs[index];
    final newFavoriteState = !song.isLiked;

    // 更新数据库
    DatabaseManager.instance.appDatabase.songDao.updateSong(
      song.copyWith(isLiked: newFavoriteState),
    );

    // 更新本地列表中的歌曲状态
    widget.songs[index] = song.copyWith(isLiked: newFavoriteState);

    // 只更新对应歌曲的收藏状态通知器
    _getFavoriteNotifier(song.id).value = newFavoriteState;

    SnackNLoad.showToast(
      newFavoriteState
          ? '已收藏 ${song.title} - ${song.artist ?? '未知艺术家'}'
          : '已取消收藏 ${song.title} - ${song.artist ?? '未知艺术家'}',
    );

    // widget.onSongUpdated?.call(song, index);
  }

  // 获取或创建收藏状态通知器
  ValueNotifier<bool> _getFavoriteNotifier(int songId) {
    return _favoriteNotifiers.putIfAbsent(
      songId,
      () => ValueNotifier<bool>(
        widget.songs.firstWhere((s) => s.id == songId).isLiked,
      ),
    );
  }

  void _handleSongDelete(int index) {
    final song = widget.songs[index];
    DatabaseManager.instance.appDatabase.songDao.deleteSongById(song.id);

    SnackNLoad.showToast("已删除 ${song.title} - ${song.artist ?? '未知艺术家'}");

    widget.onSongDeleted?.call();
  }

  @override
  void dispose() {
    // 清理 ValueNotifier 资源
    for (var notifier in _favoriteNotifiers.values) {
      notifier.dispose();
    }
    _favoriteNotifiers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedBackground(
      builder: (context, theme) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              setState(() {
                _isScrolling = true;
                _hoveredIndex = null;
              });
            } else if (notification is ScrollUpdateNotification) {
              if (!_isScrolling) {
                setState(() {
                  _isScrolling = true;
                });
              }
            } else if (notification is ScrollEndNotification) {
              setState(() {
                _isScrolling = false;
              });
            }
            return false;
          },
          child: CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              // 占位空间 - 为标题栏预留空间
              SliverToBoxAdapter(
                child: SizedBox(
                  height: CommonUtils.select(
                    theme.isFloat,
                    t: PlatformUtils.select(desktop: 120, mobile: 180),
                    f: 0,
                  ),
                ), // 标题栏高度
              ),
              // 列表内容 - 使用SliverFixedExtentList保持性能
              SliverFixedExtentList(
                itemExtent: 70, // 保持原有的性能优化
                delegate: SliverChildBuilderDelegate((context, index) {
                  final song = widget.songs[index];
                  final isHovered = !_isScrolling && _hoveredIndex == index;
                  final isSelected = ref.read(playerNotifierProvider).currentSong?.id == song.id;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final containerWidth = constraints.maxWidth;
                      final showDuration = containerWidth > 700;
                      final showAlbum = containerWidth > 500;

                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.fromLTRB(
                          8,
                          CommonUtils.select(index == 0, t: 0, f: 4),
                          8,
                          4,
                        ),
                        color: isSelected
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1)
                            : isHovered
                                ? Colors.grey.withValues(alpha: 0.1)
                                : Colors.transparent,
                        child: Row(
                          children: [
                            // 主要内容区域
                            Expanded(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) => setState(() => _hoveredIndex = index),
                                onExit: (_) => setState(() => _hoveredIndex = null),
                                child: GestureDetector(
                                  onDoubleTap: () => _handleSongPlay(index),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        // 专辑封面
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: song.albumArtPath != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(4),
                                                  child: Image.file(
                                                    File(song.albumArtPath!),
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                    cacheWidth: 150,
                                                    cacheHeight: 150,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.music_note_rounded,
                                                ),
                                        ),
                                        const SizedBox(width: 10),
                                        // 歌曲信息
                                        Expanded(
                                          child: Row(
                                            children: [
                                              // 歌曲名称
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  song.title,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: isSelected
                                                        ? Theme.of(
                                                            context,
                                                          ).colorScheme.primary
                                                        : Theme.of(context).colorScheme.onSurface,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // 艺术家
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  song.artist ?? '未知艺术家',
                                                  style: TextStyle(
                                                    color: isSelected
                                                        ? Theme.of(
                                                            context,
                                                          ).colorScheme.primary
                                                        : Theme.of(context).colorScheme.onSurface,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // 专辑
                                              if (showAlbum)
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    song.album ?? '未知专辑',
                                                    style: TextStyle(
                                                      color: isSelected
                                                          ? Theme.of(context).colorScheme.primary
                                                          : Theme.of(context).colorScheme.onSurface,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              // 时长
                                              if (showDuration)
                                                SizedBox(
                                                  width: 60,
                                                  child: Text(
                                                    CommonUtils.formatDuration(
                                                      Duration(
                                                        seconds: song.duration ?? 0,
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      color: isSelected
                                                          ? Theme.of(context).colorScheme.primary
                                                          : Theme.of(context).colorScheme.onSurface,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (widget.onSongDeleted == null) const SizedBox(width: 40),
                            // 收藏按钮
                            ValueListenableBuilder<bool>(
                              valueListenable: _getFavoriteNotifier(song.id),
                              builder: (context, isFavorite, child) {
                                return IconButton(
                                  onPressed: () => _handleFavoriteToggle(index),
                                  iconSize: 20,
                                  icon: Icon(
                                    isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                );
                              },
                            ),
                            if (widget.onSongDeleted != null)
                              // 复选框或更多菜单
                              (widget.showCheckbox
                                  ? Checkbox(
                                      value: widget.checkedIds.contains(
                                        song.id,
                                      ),
                                      onChanged: (value) {
                                        widget.onCheckboxChanged?.call(
                                          song.id,
                                          value == true,
                                        );
                                      },
                                    )
                                  : SongActionMenu(
                                      song: song,
                                      onDelete: () => _handleSongDelete(index),
                                      onImportAlbum: () async {
                                        final res = await MusicImportService.importAlbumArt(
                                          song,
                                        );
                                        SnackNLoad.showToast(
                                          res != null ? '导入成功' : '导入失败',
                                        );
                                        if (res != null) {
                                          widget.onSongUpdated?.call(
                                            song,
                                            index,
                                          );
                                        }
                                      },
                                      onFavoriteToggle: () => _handleFavoriteToggle(index),
                                      onImportLyrics: () async {
                                        final res = await MusicImportService.importLyrics(
                                          song,
                                        );
                                        SnackNLoad.showToast(
                                          res ? '导入成功' : '导入失败',
                                        );
                                        if (res) {
                                          widget.onSongUpdated?.call(
                                            song,
                                            index,
                                          );
                                        }
                                      },
                                    )),
                          ],
                        ),
                      );
                    },
                  );
                }, childCount: widget.songs.length),
              ),
              // 占位，mini播放器
              SliverToBoxAdapter(
                child: SizedBox(
                  height: CommonUtils.select(
                    theme.isFloat,
                    t: CommonUtils.select(
                      PlatformUtils.isMobileWidth(context),
                      t: 66,
                      f: 88,
                    ),
                    f: 0,
                  ),
                ), // 标题栏高度
              ),
            ],
          ),
        );
      },
    );
  }
}
