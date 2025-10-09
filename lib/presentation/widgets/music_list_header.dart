import 'package:flutter/material.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/presentation/widgets/toggleable_popup_menu.dart';

class MusicListHeader extends StatefulWidget {
  final List<Song> songs;
  final String? orderField;
  final String? orderDirection;
  final bool showCheckbox;
  final List<int> checkedIds;
  final bool allowReorder; // 新增参数：是否允许重排列
  final VoidCallback? onShowCheckboxToggle;
  final VoidCallback? onScrollToCurrent;
  final Function(String? field, String? direction)? onOrderChanged;
  final Function(bool selectAll)? onSelectAllChanged;
  final Function(String action)? onBatchAction;

  const MusicListHeader({
    super.key,
    required this.songs,
    this.orderField,
    this.orderDirection,
    this.showCheckbox = false,
    this.checkedIds = const [],
    this.allowReorder = true, // 默认允许重排列
    this.onShowCheckboxToggle,
    this.onScrollToCurrent,
    this.onOrderChanged,
    this.onSelectAllChanged,
    this.onBatchAction,
  });

  @override
  State<MusicListHeader> createState() => _MusicListHeaderState();
}

class _MusicListHeaderState extends State<MusicListHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final containerWidth = constraints.maxWidth;
          final showDuration = containerWidth > 700;
          final showAlbum = containerWidth > 500;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const SizedBox(width: 60),
                Expanded(
                  child: Row(
                    children: [
                      // 歌曲名称列
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            const Text(
                              '歌曲名称',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.allowReorder) const SizedBox(width: 4),
                            if (widget.allowReorder)
                              ToggleablePopupMenu<String>(
                                isSelected: widget.orderField == 'title',
                                tooltip: '按照歌名排序',
                                options: <MenuOption<String>>[
                                  MenuOption(label: '默认', value: null),
                                  MenuOption(label: '顺序', value: 'asc'),
                                  MenuOption(label: '倒序', value: 'desc'),
                                ],
                                selectedValue: widget.orderDirection,
                                onChanged: (value) {
                                  widget.onOrderChanged?.call(
                                    value == null ? null : 'title',
                                    value,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      // 艺术家列
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            const Text(
                              '艺术家',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.allowReorder) const SizedBox(width: 4),
                            if (widget.allowReorder)
                              ToggleablePopupMenu<String>(
                                isSelected: widget.orderField == 'artist',
                                tooltip: '按照艺术家排序',
                                options: <MenuOption<String>>[
                                  MenuOption(label: '默认', value: null),
                                  MenuOption(label: '顺序', value: 'asc'),
                                  MenuOption(label: '倒序', value: 'desc'),
                                ],
                                selectedValue: widget.orderDirection,
                                onChanged: (value) {
                                  widget.onOrderChanged?.call(
                                    value == null ? null : 'artist',
                                    value,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      // 专辑列
                      if (showAlbum)
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Text(
                                '专辑',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.allowReorder) const SizedBox(width: 4),
                              if (widget.allowReorder)
                                ToggleablePopupMenu<String>(
                                  isSelected: widget.orderField == 'album',
                                  tooltip: '按照专辑排序',
                                  options: <MenuOption<String>>[
                                    MenuOption(label: '默认', value: null),
                                    MenuOption(label: '顺序', value: 'asc'),
                                    MenuOption(label: '倒序', value: 'desc'),
                                  ],
                                  selectedValue: widget.orderDirection,
                                  onChanged: (value) {
                                    widget.onOrderChanged?.call(
                                      value == null ? null : 'album',
                                      value,
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      // 时长列
                      if (showDuration)
                        SizedBox(
                          width: 60,
                          child: Row(
                            children: [
                              const Text(
                                '时长',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.allowReorder) const SizedBox(width: 4),
                              if (widget.allowReorder)
                                ToggleablePopupMenu<String>(
                                  isSelected: widget.orderField == 'duration',
                                  tooltip: '按照时长排序',
                                  options: <MenuOption<String>>[
                                    MenuOption(label: '默认', value: null),
                                    MenuOption(label: '顺序', value: 'asc'),
                                    MenuOption(label: '倒序', value: 'desc'),
                                  ],
                                  selectedValue: widget.orderDirection,
                                  onChanged: (value) {
                                    widget.onOrderChanged?.call(
                                      value == null ? null : 'duration',
                                      value,
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: !widget.showCheckbox ? 48 : 8,
                  height: 40,
                ),
                // 批量操作菜单
                if (widget.showCheckbox)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'hide',
                        child: Text('隐藏选择框'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          '删除所选歌曲',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      widget.onBatchAction?.call(value);
                    },
                  ),
                // 全选复选框

                if (widget.showCheckbox)
                  Checkbox(
                    value: widget.checkedIds.length == widget.songs.length && widget.songs.isNotEmpty,
                    onChanged: (v) {
                      widget.onSelectAllChanged?.call(v == true);
                    },
                  ),
                // 主菜单
                if (widget.onSelectAllChanged != null)
                  if (!widget.showCheckbox)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: widget.orderField == 'id' ? Theme.of(context).colorScheme.primary : null,
                      ),
                      iconSize: 20,
                      itemBuilder: (context) => [
                        if (widget.allowReorder)
                          PopupMenuItem(
                            value: 'sort_by_id_asc',
                            child: Text(
                              widget.orderField == 'id' ? '默认排序' : '根据添加时间顺序排序',
                            ),
                          ),
                        const PopupMenuItem(value: 'show', child: Text('显示选择框')),
                        const PopupMenuItem(
                          value: 'scroll_to_current',
                          child: Text('定位到当前播放'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'show') {
                          widget.onShowCheckboxToggle?.call();
                        } else if (value == 'sort_by_id_asc' && widget.allowReorder) {
                          if (widget.orderField == 'id') {
                            widget.onOrderChanged?.call(null, null);
                          } else {
                            widget.onOrderChanged?.call('id', 'asc');
                          }
                        } else if (value == 'scroll_to_current') {
                          widget.onScrollToCurrent?.call();
                        }
                      },
                    ),
                if (widget.onSelectAllChanged == null)
                  const SizedBox(
                    width: 40,
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
