import 'package:snacknload/snacknload.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/utils/core_log.dart';
import 'package:bilibilimusic/utils/common_utils.dart';
import 'package:bilibilimusic/utils/scroll_utils.dart';
import 'package:bilibilimusic/services/player_provider.dart';
import 'package:bilibilimusic/database/database_manager.dart';
import 'package:bilibilimusic/widgets/frosted_container.dart';
import 'package:bilibilimusic/services/music_import_service.dart';
import 'package:bilibilimusic/presentation/widgets/page_header.dart';
import 'package:bilibilimusic/presentation/widgets/music_list_view.dart';
import 'package:bilibilimusic/presentation/widgets/themed_background.dart';
import 'package:bilibilimusic/presentation/widgets/music_list_header.dart';
import 'package:bilibilimusic/presentation/menu/utils/show_aware_page.dart';
import 'package:bilibilimusic/presentation/widgets/music_import_dialog.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => LibraryPageState();
}

class LibraryPageState extends ConsumerState<LibraryPage> with ShowAwarePage {
  late MusicImportService importService;
  final List<Song> _songs = [];
  Song? _currentSong;
  String? _orderField;
  String? _orderDirection;
  String? _searchKeyword;
  bool _showCheckbox = false;
  final List<int> _checkedIds = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    importService = MusicImportService();
  }

  @override
  void onPageShow() {
    CoreLog.d('LibraryPage show');
    _loadSongs().then((_) {
      _scrollToCurrentSong();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSongs() async {
    try {
      final keyword = _searchKeyword?.trim();
      final loadedSongs = await DatabaseManager.instance.appDatabase.songDao.smartSearch(
        keyword,
        orderField: _orderField,
        orderDirection: _orderDirection,
      );

      setState(() {
        _songs.clear();
        _songs.addAll(loadedSongs);
      });

      debugPrint('加载了 ${loadedSongs.length} 首歌曲');
    } catch (e) {
      debugPrint('加载歌曲失败: $e');
      if (mounted) {
        setState(() {
          _songs.clear();
        });
      }
    }
  }

  void _scrollToCurrentSong() {
    if (_currentSong != null && _songs.isNotEmpty) {
      ScrollUtils.scrollToCurrentSong(
        _scrollController,
        _songs,
        _currentSong,
      );
    }
  }

  void _onSongPlay(Song song, List<Song> playlist, int index) {
    ref.read(playerNotifierProvider.notifier).playSong(
          song,
          playlist: playlist,
          index: index,
        );
  }

  void _onSongUpdated(Song song, int? index) {
    _loadSongs().then((_) {
      final playerProvider = ref.read(playerNotifierProvider);
      if (playerProvider.currentSong?.id == song.id && index != null) {
        ref.read(playerNotifierProvider.notifier).playSong(
              _songs[index],
              playlist: _songs,
              index: index,
            );
      }
    });
  }

  void _onCheckboxChanged(int songId, bool isChecked) {
    setState(() {
      if (isChecked) {
        _checkedIds.add(songId);
      } else {
        _checkedIds.remove(songId);
      }
    });
  }

  Future<void> _onBatchAction(String action) async {
    if (action == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('确认删除'),
          content: const Text('确定要删除所选歌曲吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                '确定',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirm == true && _checkedIds.isNotEmpty) {
        final len = _checkedIds.length;
        for (final id in _checkedIds) {
          await DatabaseManager.instance.appDatabase.songDao.deleteSongById(id);
        }

        SnackNLoad.showToast('已删除$len首歌');
        await _loadSongs();

        setState(() {
          _checkedIds.clear();
          _showCheckbox = false;
        });
      } else if (_checkedIds.isEmpty) {
        SnackNLoad.showToast('请勾选你要删除的歌曲');
      }
    } else if (action == 'hide') {
      setState(() {
        _checkedIds.clear();
        _showCheckbox = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = ref.watch(playerNotifierProvider);
    _currentSong = playerProvider.currentSong;
    ref.listen(playerNotifierProvider, (previousState, newState) {
      if (previousState?.currentSong?.id != newState.currentSong?.id) {
        // _handleSongChange();
      }
    });
    return ThemedBackground(
      builder: (context, theme) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                CommonUtils.select(theme.isFloat, t: 20, f: 136),
                16.0,
                CommonUtils.select(theme.isFloat, t: 0, f: 80),
              ),
              child: MusicListView(
                songs: _songs,
                scrollController: _scrollController,
                showCheckbox: _showCheckbox,
                checkedIds: _checkedIds,
                onSongDeleted: _loadSongs,
                onSongUpdated: _onSongUpdated,
                onSongPlay: _onSongPlay,
                onCheckboxChanged: _onCheckboxChanged,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: FrostedContainer(
                enabled: theme.isFloat,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    PlatformUtils.select(desktop: 20.0, mobile: 66.0),
                    16.0,
                    0,
                  ),
                  child: PageHeader(
                    title: '音乐库',
                    songs: _songs,
                    onSearch: (keyword) async {
                      _searchKeyword = keyword;
                      await _loadSongs();
                    },
                    onImportDirectory: () async {
                      MusicImporter.importFromDirectory(
                        context,
                        onCompleted: _loadSongs,
                      );
                    },
                    onImportFiles: () async {
                      MusicImporter.importFiles(
                        context,
                        onCompleted: _loadSongs,
                      );
                    },
                    children: [
                      const SizedBox(height: 20),
                      MusicListHeader(
                        songs: _songs,
                        orderField: _orderField,
                        orderDirection: _orderDirection,
                        showCheckbox: _showCheckbox,
                        checkedIds: _checkedIds,
                        allowReorder: true,
                        onShowCheckboxToggle: () {
                          setState(() => _showCheckbox = true);
                        },
                        onScrollToCurrent: _scrollToCurrentSong,
                        onOrderChanged: (field, direction) {
                          setState(() {
                            _orderField = field;
                            _orderDirection = direction;
                          });
                          _loadSongs();
                        },
                        onSelectAllChanged: (selectAll) {
                          setState(() {
                            _checkedIds.clear();
                            if (selectAll) {
                              _checkedIds.addAll(_songs.map((s) => s.id));
                            }
                          });
                        },
                        onBatchAction: _onBatchAction,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
